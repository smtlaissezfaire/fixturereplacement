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
end