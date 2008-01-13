module FixtureReplacementController
  class MethodGenerator
    class << self
      def generate_methods(mod=FixtureReplacement)
        @module = mod
        AttributeCollection.instances.each do |attributes_instance|
          new(attributes_instance, @module).generate_methods
        end
      end
      
      def reset_module!
        @module = nil
      end
      
      def module
        @module ||= FixtureReplacement
        @module
      end
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
          obj.to_created_class_instance(args[0], self)
        end
      end
    end
    
    def generate_new_method
      obj = @object_attributes
      
      @module.module_eval do
        define_method("new_#{obj.fixture_name}") do |*args|
          obj.to_new_class_instance(args[0], self)
        end
      end
    end
  end
end