require 'ostruct'

dir = File.dirname(__FILE__) + "/fixture_replacement"
require "#{dir}/class_methods"
require "#{dir}/controller/active_record_factory"
require "#{dir}/controller/attribute_collection"
require "#{dir}/controller/delayed_evaluation_proc"
require "#{dir}/controller/method_generator"
require "#{dir}/extensions/string"

module FixtureReplacement
  extend FixtureReplacement::ClassMethods
end
