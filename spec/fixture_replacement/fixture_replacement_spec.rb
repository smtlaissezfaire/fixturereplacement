require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement, "errors" do
  it "should have a base Error class which derives from StandardError" do
    FixtureReplacement::BaseError.superclass.should == StandardError
  end
  
  it "should have InclusionError which derives from the BaseError" do
    FixtureReplacement::InclusionError.superclass.should == FixtureReplacement::BaseError
  end
  
  it "should have UnknownFixture which derives from the BaseError" do
    FixtureReplacement::UnknownFixture.superclass.should == FixtureReplacement::BaseError
  end
end
