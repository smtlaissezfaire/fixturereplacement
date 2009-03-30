module FixtureReplacement
  module ClassMethods
    def attributes_for(fixture_name, options={}, fixture_attributes_class=FixtureReplacementController::AttributeCollection, &blk)
      fixture_attributes_class.new(fixture_name, {
        :class      => options[:class],
        :from       => options[:from],
        :attributes => blk
      })
    end
    
    attr_writer :defaults_file

    def defaults_file
      @defaults_file ||= "#{RAILS_ROOT}/db/example_data.rb"
    end

    def included(included_mod)
      FixtureReplacementController::MethodGenerator.generate_methods
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