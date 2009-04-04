require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  before do
    FixtureReplacement.reset!
  end

  after do
    FixtureReplacement.reset!
  end

  it "should have create as the default" do
    FixtureReplacement.create_dependent_objects?.should be_true
  end

  it "should be able to set dependent object creation" do
    FixtureReplacement.create_dependent_objects = false
    FixtureReplacement.create_dependent_objects?.should be_false
  end

  it "should have the default_method as :create when create_dependent_objects?" do
    FixtureReplacement.create_dependent_objects = true
    FixtureReplacement.default_method.should equal(:create)
  end

  it "should have the default_method as :new when create_dependent_objects == false" do
    FixtureReplacement.create_dependent_objects = false
    FixtureReplacement.default_method.should equal(:new)
  end
  
  describe "random_string" do
    before do
      @fr = FixtureReplacement
    end
    
    it "should not be the same as another randomly generated string" do
      @fr.random_string.should_not == @fr.random_string
    end

    it "should by default be 10 characters long" do
      @fr.random_string.size.should == 10
    end

    it "should be able to specify the length of the random string" do
      @fr.random_string(100).size.should == 100
    end

    it "should only generate lowercase letters" do
      s = @fr.random_string(100)
      s.upcase.should == s.swapcase
    end
  end
end