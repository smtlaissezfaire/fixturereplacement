module FixtureReplacement
  module Controller
    #
    # "Fixture" definitions are defined in db/example_data.rb.
    # See the README for more info
    #
    class MethodGenerator
      class << self
        def generate_methods
          AttributeCollection.instances.each do |attributes_instance|
            new(attributes_instance).generate_methods
          end
        end
      end
    
      def initialize(object_attributes)
        @object_attributes = object_attributes
      end
    
      def generate_methods
        generate_default_method
        generate_new_method
        generate_create_method
      end
    
      def generate_default_method
        obj = @object_attributes
      
        fixture_replacement_module.module_eval do
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
      
        fixture_replacement_module.module_eval do
          define_method("create_#{obj.fixture_name}") do |*args|
            obj.to_created_class_instance(args[0], self)
          end
        end
      end
    
      def generate_new_method
        obj = @object_attributes
      
        fixture_replacement_module.module_eval do
          define_method("new_#{obj.fixture_name}") do |*args|
            obj.to_new_class_instance(args[0], self)
          end
        end
      end
    
    private
    
      def fixture_replacement_module
        @fixture_replacement_module ||= ::FixtureReplacement::Controller.fr
      end
    end
  end
end