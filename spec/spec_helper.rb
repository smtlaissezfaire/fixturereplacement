
require "rubygems"
require "spec"

require File.dirname(__FILE__) + "/spec_helpers"
include SpecHelperFunctions
setup_database_connection

require File.dirname(__FILE__) + "/../lib/fixture_replacement"
require File.dirname(__FILE__) + "/../lib/fr"
require File.dirname(__FILE__) + "/fixture_replacement/fixtures/classes"

Spec::Runner.configure do |config|
  config.prepend_before(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end
  
  config.prepend_after(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end
end
