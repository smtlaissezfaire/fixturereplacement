module FixtureReplacementController
  class MethodGenerator
    class << self
      
      def generate_methods(mod=FixtureReplacement)
        @module = mod
        Attributes.instances.each do |attributes_instance|
          new(attributes_instance, @module).generate_methods
        end
      end
      
      def module
        @module ||= FixtureReplacement
      end
      
    end
    
    def initialize(object_attributes, module_class)
      @object_attributes = object_attributes
      @object_attributes.merge!
      @module_class = module_class
    end
    
    def generate_methods
      generate_default_method
      generate_new_method
      generate_create_method
    end
    
    def generate_default_method
      obj = @object_attributes
      
      @module_class.module_eval do
        define_method("default_#{obj.fixture_name}") do |*args|
          hash = args[0] || Hash.new
          DelayedEvaluationProc.new { 
            [obj.fixture_name, hash]
          }
        end
      end
    end
    
    def generate_create_method
      obj = @object_attributes
      
      @module_class.module_eval do
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
      
      @module_class.module_eval do
        define_method("new_#{obj.fixture_name}") do |*args|
          merged_hash = args[0] ? obj.hash.merge(args[0]) : obj.hash
          new_object = obj.of_class.new
          merged_hash.each { |key, value| new_object.send("#{key}=", value) }
          
          new_object
        end
      end
    end
  end
end