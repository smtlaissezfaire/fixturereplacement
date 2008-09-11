# Copyright 2007-2008 Scott Taylor <scott@railsnewbie.com>
# See the file LICENSE in the root of this project for the conditions
# of the copyright.
module FixtureReplacement
  class BaseError      < StandardError; end
  class InclusionError < BaseError;     end
  class UnknownFixture < BaseError;     end
  
  UNDEFINED = FixtureReplacementController::UndefinedValue.new
  
  autoload :ClassMethods, File.dirname(__FILE__) + "/class_methods"
  autoload :Version,      File.dirname(__FILE__) + "/version"
  
  extend ClassMethods
end

FR = FixtureReplacement
