require_dependency 'ostruct'

dir = File.dirname(__FILE__) + "/fixture_replacement"
require_dependency "#{dir}/class_methods"
require_dependency "#{dir}/controller/active_record_factory"
require_dependency "#{dir}/controller/attribute_collection"
require_dependency "#{dir}/controller/delayed_evaluation_proc"
require_dependency "#{dir}/controller/method_generator"
require_dependency "#{dir}/extensions/string"

module FixtureReplacement
  extend FixtureReplacement::ClassMethods
end

unless defined?(FR)
  FR = FixtureReplacement
end