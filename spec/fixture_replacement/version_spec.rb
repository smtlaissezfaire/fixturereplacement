require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  it "should be at version 2.0.1" do
    FixtureReplacement::VERSION.should == "2.1.1"
  end
end
