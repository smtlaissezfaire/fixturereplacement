require 'rubygems'
require 'active_support' 

class FixtureReplacementError < StandardError; end

module FixtureReplacement  
  class << self    
    def reset_excluded_environments!
      @excluded_environments = ["production"]
    end
    
    def excluded_environments
      @excluded_environments ||= ["production"]
    end
  
    attr_writer :excluded_environments
  
    def included(included_mod)
      if environment_in_excluded_environments?
        raise FixtureReplacementError, "FixtureReplacement cannot be included in the #{Object.const_get(:RAILS_ENV)} environment!"
      end
      FixtureReplacementGenerator.generate_methods
    end
    
  private
  
    def environment_in_excluded_environments?
      return false unless Object.const_defined?(:RAILS_ENV)
      rails_env = Object.const_get(:RAILS_ENV)
      excluded_environments.include?(rails_env) ? true : false
    end
  end
end


