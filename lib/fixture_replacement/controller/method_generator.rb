module FixtureReplacementController
  class MethodGenerator
    class << self      
      def generate_methods(mod=FixtureReplacement)
        @module = mod
        Attributes.instances.each do |attributes_instance|
          new(attributes_instance, @module).generate_methods
        end
      end
      
      attr_reader :module
    end
    
    def initialize(object_attributes, module_class=FixtureReplacement)
      @object_attributes = object_attributes
      @module = module_class
    end
    
    attr_reader :module
    
    def generate_methods
      generate_default_method
      generate_new_method
      generate_create_method
    end
    
    def generate_default_method
      obj = @object_attributes
      
      @module.module_eval do
        define_method("default_#{obj.fixture_name}") do |*args|
          hash = args[0] || Hash.new
          DelayedEvaluationProc.new { 
            [obj, hash]
          }
        end
      end
    end
    
    def generate_create_method
      obj = @object_attributes
      
      @module.module_eval do
        define_method("create_#{obj.fixture_name}") do |*args|
          hash = args[0] || Hash.new
          created_obj = self.send("new_#{obj.fixture_name}", hash)
          created_obj.save!
          created_obj
        end
      end
    end
    
    def generate_new_method
      obj = @object_attributes
      
      @module.module_eval do
        define_method("new_#{obj.fixture_name}") do |*args|
          obj.merge!
          merged_hash = args[0] ? obj.hash.merge(args[0]) : obj.hash
          new_object = obj.of_class.new
          merged_hash.each do |key, value|          
            if value.class == DelayedEvaluationProc
              default_obj, params = value.call
              value = self.send("create_#{default_obj.fixture_name}", params)
            end
            new_object.send("#{key}=", value)             
          end
          
          new_object
        end
      end
    end
  end
end