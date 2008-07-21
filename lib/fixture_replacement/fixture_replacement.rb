module FixtureReplacement
  class InclusionError < StandardError; end
  autoload :ClassMethods, File.dirname(__FILE__) + "/class_methods"
  extend ClassMethods
end


