require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe Attributes do
    
    before :each do
      Attributes.clear_out_instances!
    end
    
    it "should add the instance to the global attributes" do
      a = Attributes.new({:fixture_name => :foo})
      Attributes.instances.should == [a]
    end
    
    it "should have no instances when none have been created" do
      Attributes.instances.should == []
    end
    
    it "should have two instances when two have been created" do
      a1 = Attributes.new({:fixture_name => :foo})
      a2 = Attributes.new({:fixture_name => :foo})
      Attributes.instances.should == [a1, a2]
    end
    
    it "should have the fixture name as accessible" do
      a1 = Attributes.new({:fixture_name => :foo})
      a1.fixture_name.should == :foo
    end
    
    it "should raise an error if no fixture_name is given" do
      lambda {
        Attributes.new({})
      }.should raise_error
    end
    
  end  
end
