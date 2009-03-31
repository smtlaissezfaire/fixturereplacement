module FixtureReplacement
  class MethodGenerator
    
    class << self
      def generate_methods(evaluation_module = FixtureReplacement)
        AttributeBuilder.instances.each do |builder|
          new(builder, evaluation_module).generate_methods
        end
      end
    end
    
    def initialize(builder, evaluation_module = FixtureReplacement)
      @builder           = builder
      @evaluation_module = evaluation_module
    end
    
    def generate_methods
      generate_default_method
      generate_new_method
      generate_create_method
    end
    
    def generate_default_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("default_#{builder.fixture_name}") do |*args|
          lambda do
            __send__("create_#{builder.fixture_name}", args[0] || Hash.new)
          end
        end
      end
    end
    
    def generate_create_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("create_#{builder.fixture_name}") do |*args|
          builder.to_created_class_instance(args[0], self)
        end
      end
    end
    
    def generate_new_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("new_#{builder.fixture_name}") do |*args|
          builder.to_new_class_instance(args[0], self)
        end
      end
    end
  end
end