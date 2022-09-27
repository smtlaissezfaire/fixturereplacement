module FixtureReplacement
  class MethodGenerator
    def initialize(builder, evaluation_module)
      @builder           = builder
      @evaluation_module = evaluation_module
    end

    def generate_methods
      builder       = @builder
      builder_name  = builder.fixture_name

      @evaluation_module.module_eval do
        define_method("valid_#{builder_name}_attributes") do |*args|
          obj = __send__ "new_#{builder_name}"
          obj.attributes
        end

        define_method("create_#{builder_name}") do |*args|
          obj = __send__("new_#{builder_name}", *args)
          obj.save!
          obj
        end

        define_method("new_#{builder_name}") do |*args|
          new_object = builder.instantiate(*args)
        end
      end
    end
  end
end
