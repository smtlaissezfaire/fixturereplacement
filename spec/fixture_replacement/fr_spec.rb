require File.dirname(__FILE__) + "/../spec_helper"

describe FR do
  it "should alias FixtureReplacement" do
    FR.should equal(FixtureReplacement)
  end
end