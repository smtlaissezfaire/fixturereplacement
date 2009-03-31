require 'ostruct'

dir = File.dirname(__FILE__) + "/fixture_replacement"
load "#{dir}/version.rb"
load "#{dir}/class_methods.rb"
load "#{dir}/active_record_factory.rb"
load "#{dir}/attribute_builder.rb"
load "#{dir}/method_generator.rb"
load "#{dir}/extensions/string.rb"

module FixtureReplacement
  include FixtureReplacement::Version
  extend FixtureReplacement::ClassMethods
end

FR = FixtureReplacement unless defined?(FR)