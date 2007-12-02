module FixtureReplacement
  module ClassMethods
      def attributes_for(fixture_name, options={}, fixture_attributes_class=FixtureReplacementController::Attributes, &blk)
        fixture_attributes_class.new(fixture_name, {
          :class => options[:class],
          :from => options[:from],
          :attributes => blk
        })
      end

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
        if environment_in_excluded_environments?
          raise FixtureReplacement::InclusionError, "FixtureReplacement cannot be included in the #{Object.const_get(:RAILS_ENV)} environment!"
        end
        FixtureReplacementController::MethodGenerator.generate_methods
      end

    private

      def environment_in_excluded_environments?
        return false unless Object.const_defined?(:RAILS_ENV)
        rails_env = Object.const_get(:RAILS_ENV)
        excluded_environments.include?(rails_env) ? true : false
      end

      def rails_root
        Object.const_defined?(:RAILS_ROOT) ? Object.const_get(:RAILS_ROOT) : nil      
      end
  end
end