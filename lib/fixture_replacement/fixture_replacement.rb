# Copyright 2007-2008 Scott Taylor <scott@railsnewbie.com>
# See the file LICENSE in the root of this project for the conditions
# of the copyright.
module FixtureReplacement
  class BaseError      < StandardError; end
  class InclusionError < BaseError;     end
  class UnknownFixture < BaseError;     end
  
  dir = File.dirname(__FILE__)
  
  autoload :ClassMethods,   "#{dir}/class_methods"
  autoload :Version,        "#{dir}/version"
  autoload :UndefinedValue, "#{dir}/class_methods"
  autoload :Controller,     "#{dir}/controller"
  
  # Pass FR::UNDEFINED as a value to prevent FixtureReplacement
  # from assigning the value from example_data.rb
  UNDEFINED = FixtureReplacement::Controller::UndefinedValue.new
  
  extend ClassMethods
end

FR = FixtureReplacement
