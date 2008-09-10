# Copyright 2007-2008 Scott Taylor <scott@railsnewbie.com>
# See the file LICENSE in the root of this project for the conditions
# of the copyright.
module FixtureReplacement
  class InclusionError < StandardError; end
  class UnknownFixture < StandardError; end
  
  autoload :ClassMethods, File.dirname(__FILE__) + "/class_methods"
  autoload :Version,      File.dirname(__FILE__) + "/version"
  
  extend ClassMethods
end
