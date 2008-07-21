module FixtureReplacement
  class InclusionError < StandardError; end
  
  autoload :ClassMethods, File.dirname(__FILE__) + "/class_methods"
  
  class << self
    include FixtureReplacement::ClassMethods
  end
end


