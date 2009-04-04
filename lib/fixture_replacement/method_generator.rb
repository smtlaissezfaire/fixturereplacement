module FixtureReplacement
  class MethodGenerator
    def initialize(builder, evaluation_module)
      @builder           = builder
      @evaluation_module = evaluation_module
    end
    
    def generate_methods
      builder = @builder
      
      @evaluation_module.module_eval do
        define_method("valid_#{builder.fixture_name}_attributes") do |*args|
          builder.to_hash(*args)
        end

        define_method("default_#{builder.fixture_name}") do |*args|
          lambda do
            __send__("create_#{builder.fixture_name}", *args)
          end
        end

        define_method("create_#{builder.fixture_name}") do |*args|
          obj = __send__("new_#{builder.fixture_name}", *args)
          obj.save!
          obj
        end
        
        define_method("new_#{builder.fixture_name}") do |*args|
          new_object = builder.active_record_class.new
          
          attributes = __send__("valid_#{builder.fixture_name}_attributes", *args)
          attributes.each { |attr, value| new_object.__send__("#{attr}=", value) }
          new_object
        end
      end
    end
  end
end
