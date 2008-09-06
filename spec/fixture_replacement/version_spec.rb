require File.dirname(__FILE__) + "/../spec_helper"

module FixtureReplacement
  describe Version do
    it "should be at major version 2" do
      Version::MAJOR.should equal(2)
    end
    
    it "should be at minor version 8" do
      Version::MINOR.should equal(8)
    end
    
    it "should be at tiny version 0" do
      Version::TINY.should equal(0)
    end
  end
end
