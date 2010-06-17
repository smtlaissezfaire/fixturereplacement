require File.dirname(__FILE__) + "/spec_helpers"
require File.dirname(__FILE__) + "/fixture_replacement/fixtures/classes"

Spec::Runner.configure do |config|
  config.prepend_before(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end

  config.prepend_after(:each) do
    FixtureReplacement::AttributeBuilder.clear_out_instances!
  end
end
