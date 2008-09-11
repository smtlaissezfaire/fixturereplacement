require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe UndefinedValue do
    it "should be a kind of class" do
      UndefinedValue.should be_a_kind_of(Class)
    end
  end
end

describe "FixtureReplacement" do
  it "should have the UNDEFINED constant" do
    lambda { 
      FixtureReplacement::UNDEFINED    
    }.should_not raise_error
  end
  
  it "should have FR::UNDEFINED" do
    lambda { 
      FR::UNDEFINED
    }.should_not raise_error
  end
end
