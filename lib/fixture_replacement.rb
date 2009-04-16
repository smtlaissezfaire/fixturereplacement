require 'ostruct'

dir = File.dirname(__FILE__) + "/fixture_replacement"
load "#{dir}/version.rb"
load "#{dir}/class_methods.rb"
load "#{dir}/attribute_builder.rb"
load "#{dir}/method_generator.rb"

module FixtureReplacement
  include FixtureReplacement::Version
  extend FixtureReplacement::ClassMethods
end

FixtureReplacement.load_example_data
