
require "rubygems"
require "spec"

unless defined?(RAILS_ROOT)
  RAILS_ROOT = "."
end

require File.dirname(__FILE__) + "/spec_helpers"
include SpecHelperFunctions
setup_database_connection

require File.dirname(__FILE__) + "/../lib/fixture_replacement"
require File.dirname(__FILE__) + "/fixture_replacement/fixtures/classes"

def use_module(&block)
  mod = Module.new
  mod.extend(FixtureReplacement::ClassMethods)
  mod.instance_eval(&block)
  
  obj = Object.new
  obj.extend mod
  obj
end

Spec::Runner.configure do |config|
  config.prepend_before(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end
  
  config.prepend_after(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end
end
