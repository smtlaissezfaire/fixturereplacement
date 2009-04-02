module FixtureReplacement
  class MethodGenerator
    
    class << self
      def generate_methods(evaluation_module)
        AttributeBuilder.instances.each do |builder|
          new(builder, evaluation_module).generate_methods
        end
      end
    end
    
    def initialize(builder, evaluation_module)
      @builder           = builder
      @evaluation_module = evaluation_module
    end
    
    def generate_methods
      generate_valid_attributes_method
      generate_default_method
      generate_new_method
      generate_create_method
    end
    
    def generate_valid_attributes_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("valid_#{builder.fixture_name}_attributes") do
          builder.to_hash
        end
      end
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
          obj = send("new_#{builder.fixture_name}", *args)
          obj.save!
          obj
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