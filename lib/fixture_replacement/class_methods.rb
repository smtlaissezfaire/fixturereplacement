module FixtureReplacement
  module ClassMethods
    def attributes_for(fixture_name, options={}, &block)
      builder = AttributeBuilder.new(fixture_name, options, &block)
      MethodGenerator.new(builder, self).generate_methods
    end
    
    # Any user defined instance methods (as well as default_*) need the module's class scope to be
    # accessible inside the block given to attributes_for
    #
    # Addresses bug #16858 (see CHANGELOG)
    def method_added(method)
      module_function method if method != :method_added
      public method
    end
    
    def reset!
      @create_dependent_objects = true
    end
    
    attr_writer :create_dependent_objects
    
    def create_dependent_objects?
      if defined? @create_dependent_objects
        @create_dependent_objects
      else
        @create_dependent_objects = true
      end
    end
    
    def default_method
      create_dependent_objects? ? :create : :new
    end
  end
end
