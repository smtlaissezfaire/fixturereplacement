$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "."))
load "fixture_replacement/version.rb"
load "fixture_replacement/class_methods.rb"
load "fixture_replacement/attribute_builder.rb"
load "fixture_replacement/method_generator.rb"

module FixtureReplacement
  class InvalidInstance < StandardError; end

  include FixtureReplacement::Version
  extend FixtureReplacement::ClassMethods
  extend self
end

load "fr.rb"

