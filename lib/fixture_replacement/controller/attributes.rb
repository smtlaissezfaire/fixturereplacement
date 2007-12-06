module FixtureReplacementController
  class Attributes
    class << self
      def instances
        @instances ||= []
      end
      
      def add_instance(instance)
        @instances ||= []
        @instances << instance
      end
      
      def clear_out_instances!
        @instances = nil
      end
      
      def find_by_fixture_name(arg)
        instances.each do |instance|
          if instance.fixture_name == arg
            return instance
          end
        end
        return nil
      end
    end
    
    def initialize(fixture_name, h={})
      @fixture_name = fixture_name
      assign_from_constructor(h)
      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    attr_reader :from

    # I would really like to name this method class, but I'm
    # sure you can see the name conflict
    def of_class
      begin
        @class || find_by_fixture_name(@from).of_class
      rescue
        constantize(fixture_name)
      end
    end
    
    def hash
      return @merged_hash if @merged_hash
      os = OpenStruct.new
      @attributes_proc.call(os)
      os.to_hash
    end
    
    def merge!
      if from = find_by_fixture_name(self.from)
        @merged_hash = from.hash.merge(self.hash)
      end
    end
    
    def to_new_class_instance(hash={}, caller=self)
      self.merge!
      merged_hash = hash ? self.hash.merge(hash) : self.hash
      new_object = self.of_class.new
      
      merged_hash.each do |key, value|          
        if value.is_a? DelayedEvaluationProc
          value = find_value_from_delayed_evaluation_proc(value, caller)
        end
        new_object.__send__("#{key}=", value)             
      end
      new_object
    end
    
    def to_created_class_instance(hash={}, caller=self)
      created_obj = to_new_class_instance(hash, caller)
      created_obj.save!
      created_obj
    end
    
  private
  
    def find_value_from_delayed_evaluation_proc(value, caller)
      default_obj, params = value.call
      value = caller.__send__("create_#{default_obj.fixture_name}", params)
    end
  
    def assign_from_constructor(hash_given)
      @attributes_proc = hash_given[:attributes] || lambda { Hash.new }
      @from, @class = hash_given[:from], hash_given[:class]
    end
  
    attr_reader :hash_given
  
    def find_by_fixture_name(symbol)
      self.class.find_by_fixture_name(symbol)
    end
    
    def constantize(symbol)
      symbol.to_s.camelize.constantize
    end
  end
end