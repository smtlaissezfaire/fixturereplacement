module FixtureReplacement
  class MethodGenerator
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
            __send__("create_#{builder.fixture_name}", *args)
          end
        end
      end
    end
    
    def generate_create_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("create_#{builder.fixture_name}") do |*args|
          obj = __send__("new_#{builder.fixture_name}", *args)
          obj.save!
          obj
        end
      end
    end
    
    def generate_new_method
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("new_#{builder.fixture_name}") do |*args|
          new_object = builder.active_record_class.new
          
          attributes = builder.to_hash(*args)
          attributes.each do |key, value|
            new_object.__send__("#{key}=", value)
          end
          
          new_object
        end
      end
    end
  end
end
