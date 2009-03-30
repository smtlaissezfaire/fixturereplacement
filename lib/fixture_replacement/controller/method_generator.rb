module FixtureReplacementController
  class MethodGenerator
    
    class << self
      def generate_methods(evaluation_module = FixtureReplacement)
        AttributeBuilder.instances.each do |attributes_instance|
          new(attributes_instance, evaluation_module).generate_methods
        end
      end
    end
    
    def initialize(object_attributes, evaluation_module = FixtureReplacement)
      @object_attributes = object_attributes
      @evaluation_module = evaluation_module
    end
    
    def generate_methods
      generate_default_method
      generate_new_method
      generate_create_method
    end
    
    def generate_default_method
      obj = @object_attributes
      
      @evaluation_module.module_eval do
        define_method("default_#{obj.fixture_name}") do |*args|
          lambda do
            __send__("create_#{obj.fixture_name}", args[0] || Hash.new)
          end
        end
      end
    end
    
    def generate_create_method
      obj = @object_attributes
      
      @evaluation_module.module_eval do
        define_method("create_#{obj.fixture_name}") do |*args|
          obj.to_created_class_instance(args[0], self)
        end
      end
    end
    
    def generate_new_method
      obj = @object_attributes
      
      @evaluation_module.module_eval do
        define_method("new_#{obj.fixture_name}") do |*args|
          obj.to_new_class_instance(args[0], self)
        end
      end
    end
  end
end