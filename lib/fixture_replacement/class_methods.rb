module FixtureReplacement
  module ClassMethods
    include FixtureReplacement::RandomDataGenerators

    def included(_other_mod)
      FixtureReplacement.load!
    end

    def attributes_for(fixture_name, options={}, &block)
      builder = AttributeBuilder.new(fixture_name, options, &block)
      MethodGenerator.new(builder, self).generate_methods
    end

    def validate!
      AttributeBuilder.validate_instances!
    end

    def load!
      load "#{rails_root}/db/example_data.rb"
    rescue LoadError, NameError
      # no-op.  If the file is not found, don't panic
    end

    def rails_root
      ::Rails.root
    rescue NameError
      "."
    end

    def reload!
      AttributeBuilder.clear_out_instances!
      load File.expand_path(File.dirname(__FILE__) + "/../fixture_replacement.rb")
    end
  end
end
