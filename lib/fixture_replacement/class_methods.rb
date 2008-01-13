module FixtureReplacement
  module ClassMethods
    def attributes_for(fixture_name, options={}, fixture_attributes_class=FixtureReplacementController::Attributes, &blk)
      fixture_attributes_class.new(fixture_name, {
        :class => options[:class],
        :from => options[:from],
        :attributes => blk
      })
    end
    
    def after_include(&block)
      @after_include_block = block
    end

    attr_reader :after_include_block
    attr_writer :defaults_file

    def defaults_file
      @defaults_file ||= "#{rails_root}/db/example_data.rb"
    end

    def reset_excluded_environments!
      @excluded_environments = ["production"]
    end

    def excluded_environments
      @excluded_environments ||= ["production"]
    end

    attr_writer :excluded_environments

    def included(included_mod)
      raise_if_environment_is_in_excluded_environments
      FixtureReplacementController::MethodGenerator.generate_methods
      call_after_include_if_exists
    end
    
    # Any user defined instance methods (as well as default_*) need the module's class scope to be
    # accessible inside the block given to attributes_for
    #
    # Addresses bug #16858 (see CHANGELOG)
    def method_added(method)
      module_function method if method != :method_added
    end

  private
  
    def call_after_include_if_exists
      if after_include_block
        @after_include_block.call
      end
    end
    
    def raise_if_environment_is_in_excluded_environments
      if environment_is_in_excluded_environments?
        raise FixtureReplacement::InclusionError, "FixtureReplacement cannot be included in the #{Object.const_get(:RAILS_ENV)} environment!"
      end
    end

    def environment_is_in_excluded_environments?
      return false unless defined?(RAILS_ENV)
      excluded_environments.include?(RAILS_ENV) ? true : false
    end

    def rails_root
      defined?(RAILS_ROOT) ? RAILS_ROOT : nil      
    end
  end
end