# This has to be here because bundler does stupid
# ass things with the $LOAD_PATH - it doesn't respect
# the environment it is required in, and decides to use it's
# own concept of the $LOAD_PATH.
require "spec/adapters/mock_frameworks/rspec"
require "spec/runner/formatter/progress_bar_formatter"

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
