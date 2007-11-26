require File.dirname(__FILE__) + "/../spec_helper"

context = self

describe "FixtureReplacement" do
  it "should raise the error: 'Error in FixtureReplacement plugin: ..." do
    context.stub!(:require).and_raise("could not find file!")
    lambda {
      load File.dirname(__FILE__) + "/../../lib/fixture_replacement.rb"
    }.should raise_error(RuntimeError, "Error in FixtureReplacement Plugin: could not find file!")
  end
end