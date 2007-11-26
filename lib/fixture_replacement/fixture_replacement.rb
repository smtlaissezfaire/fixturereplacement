require 'rubygems'
require 'active_support' 

class FixtureReplacementError < StandardError; end

module FixtureReplacement  
  def self.included(included_mod)
    FixtureReplacementGenerator.generate_methods
  end
end


