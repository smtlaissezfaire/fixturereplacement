module FixtureReplacement
  module ClassMethods
    def attributes_for(fixture_name, options={}, &block)
      AttributeBuilder.new(fixture_name, options, &block)
    end
    
    def included(included_mod)
      MethodGenerator.generate_methods
    end
    
    # Any user defined instance methods (as well as default_*) need the module's class scope to be
    # accessible inside the block given to attributes_for
    #
    # Addresses bug #16858 (see CHANGELOG)
    def method_added(method)
      module_function method if method != :method_added
    end
  end
end