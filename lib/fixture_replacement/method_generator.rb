module FixtureReplacement
  class MethodGenerator
    def initialize(builder, evaluation_module)
      @builder           = builder
      @evaluation_module = evaluation_module
    end
    
    def generate_methods
      builder       = @builder
      builder_name  = builder.fixture_name
      builder_class = builder.active_record_class
      default_method = @evaluation_module.default_method
      
      @evaluation_module.module_eval do
        define_method("valid_#{builder_name}_attributes") do |*args|
          builder.to_hash(*args)
        end

        define_method("default_#{builder_name}") do |*args|
          lambda do
            __send__("#{default_method}_#{builder_name}", *args)
          end
        end

        define_method("create_#{builder_name}") do |*args|
          obj = __send__("new_#{builder_name}", *args)
          obj.save!
          obj
        end
        
        define_method("new_#{builder_name}") do |*args|
          new_object = builder_class.new
          
          attributes = __send__("valid_#{builder_name}_attributes", *args)
          attributes.each { |attr, value| new_object.__send__("#{attr}=", value) }
          new_object
        end
      end
    end
  end
end
