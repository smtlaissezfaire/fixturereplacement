require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  it "should be at the right version" do
    FixtureReplacement::VERSION.should == "4.1.0"
  end
end
