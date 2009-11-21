module FixtureReplacement
  module ClassMethods
    def attributes_for(fixture_name, options={}, &block)
      builder = AttributeBuilder.new(fixture_name, options, &block)
      MethodGenerator.new(builder, self).generate_methods
    end

    def validate!
      AttributeBuilder.validate_instances!
    end

    def random_string(length=10)
      chars = ("a".."z").to_a
      string = ""
      1.upto(length) { |i| string << chars[rand(chars.size-1)]}
      string
    end

    def load_example_data
      load "#{rails_root}/db/example_data.rb"
    rescue LoadError
      # no-op.  If the file is not found, don't panic
    end

    def rails_root
      defined?(RAILS_ROOT) ? RAILS_ROOT : "."
    end

    def reload!
      AttributeBuilder.clear_out_instances!
      load File.expand_path(File.dirname(__FILE__) + "/../fixture_replacement.rb")
    end

  private

    # Any user defined instance methods need the module's class scope to be
    # accessible inside the block given to attributes_for
    #
    # Addresses bug #16858 (see CHANGELOG)
    def method_added(method)
      module_function method if method != :method_added
      public method
    end
  end
end
