require 'rubygems'
require 'active_support' 

class FixtureReplacementError < StandardError; end

module FixtureReplacement  
  class << self    
    def excluded_environments
      @excluded_environments ||= ["production"]
    end
  
    def excluded_environments=(array)
      @excluded_environments = array
    end
  
    def included(included_mod)
      FixtureReplacementGenerator.generate_methods
    end
  end
end


