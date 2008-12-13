require 'rubygems'
require 'spec'

Spec::Runner.configure do |config|
  require File.dirname(__FILE__) + "/spec_helpers"
  
  include SpecHelperFunctions
  setup_tests
  
  config.prepend_before(:each) do
    FixtureReplacement::Controller::AttributeCollection.clear_out_instances!
  end
  
  config.prepend_after(:each) do
    FixtureReplacement::Controller::AttributeCollection.clear_out_instances!
  end
end
