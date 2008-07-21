module FixtureReplacement
  class InclusionError < StandardError; end
  autoload :ClassMethods, File.dirname(__FILE__) + "/class_methods"
  autoload :Version,      File.dirname(__FILE__) + "/version"
  extend ClassMethods
end


