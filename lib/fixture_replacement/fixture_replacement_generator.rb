class FixtureReplacementGenerator

  class << self
    def generate_methods(mod=FixtureReplacement)
      mod.instance_methods.each do |method|          
        if method =~ /(.*)_attributes/
          options = {
            :method_base_name => $1
          }
          generator = new(options, mod)          
          generator.generate_default_method
          generator.generate_new_method
          generator.generate_create_method
        end
      end
    end
    
    # This uses a DelayedEvaluationProc, not a typical proc, for type checking.
    # It may be absurd to try to store a proc in a database, but even if someone tries,
    # they won't get an error from FixtureReplacement, since the error would be incredibly unclear
    def merge_unevaluated_method(obj, method_for_instantiation, hash={})
      hash.each do |key, value|
        if value.kind_of?(DelayedEvaluationProc)
          method_base_name, args = value.call
          hash[key] = obj.send("#{method_for_instantiation}_#{method_base_name}", args)
        end
      end
    end
  end
  
  attr_reader :method_base_name
  attr_reader :model_class
  attr_reader :fixture_module
  
  def initialize(options={}, fixture_mod=::FixtureReplacement)
    @method_base_name = options[:method_base_name]
    @fixture_module = fixture_mod    
    assign_init_variables
    create_merge_and_evaluate_from_hash
  end
  
  def generate_default_method
    # we need to make these sorts of assignments for reasons of scope
    # if they are attr_readers or plain old instance_variables, they won't
    # be seen inside define_method
    model_as_string, default_method = method_base_name, @default_method

    fixture_module.module_eval do
      define_method(default_method) do |*args|
        DelayedEvaluationProc.new do
          [model_as_string, *args]
        end
      end
    end
  end
  
  def generate_create_method
    new_method, create_method, attributes_method, class_name = @new_method, @create_method, @attributes_method, @class_name
    
    fixture_module.module_eval do
      define_method(create_method) do |*args|
        evaluated_hash = merge_and_evaluate_from_hash(args[0], attributes_method)
        
        # we are NOT doing the following, because of attr_protected:
        #   obj = class_name.create!(evaluated_hash)
        obj = class_name.new
        evaluated_hash.each { |key, value| obj.send("#{key}=", value) }
        obj.save!
        obj          
      end
    end
  end
  
  def generate_new_method
    new_method, attributes_method, class_name = @new_method, @attributes_method, @class_name

    fixture_module.module_eval do
      define_method new_method do |*args|
        evaluated_hash = merge_and_evaluate_from_hash(args[0], attributes_method)
        
        # we are also doing the following because of attr_protected:
        obj = class_name.new
        evaluated_hash.each { |key, value| obj.send("#{key}=", value) }
        obj
      end
    end
  end
  
private

  def add_to_class_singleton(obj)
    string = self.class.const_get(@model_class)

    method_base_name.instance_eval <<-HERE
      def to_class
        #{string}
      end
    HERE
  end
  
  def assign_init_variables
    @model_class = method_base_name.camelize
    add_to_class_singleton(@model_class)
    
    @class_name = method_base_name.to_class
    @new_method = "new_#{method_base_name}".to_sym
    @create_method = "create_#{method_base_name}".to_sym
    @attributes_method = "#{method_base_name}_attributes".to_sym
    @default_method = "default_#{method_base_name}".to_sym
  end
  
  def create_merge_and_evaluate_from_hash
    fixture_module.module_eval do
      define_method(:merge_and_evaluate_from_hash) do |hash, attributes_method|
        hash_given = hash || Hash.new
        merged_hash = self.send(attributes_method).merge(hash_given)
        evaluated_hash = FixtureReplacementGenerator.merge_unevaluated_method(self, :create, merged_hash)
      end
      
      private :merge_and_evaluate_from_hash
    end
  end
  
end

