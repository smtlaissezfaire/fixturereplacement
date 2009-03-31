require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement, "attributes_for" do
  before :each do
    @fixture_attribute = FixtureReplacement::AttributeBuilder
    @fixture_attribute.stub!(:new)
  end
  
  it "should take a fixture name" do
    FixtureReplacement.attributes_for(:foo) {}
  end
  
  it "should take a fixture name along with a hash of attributes" do
    FixtureReplacement.attributes_for(:foo, :bar => :baz, :baz => :zed) {}
  end
  
  it "should create a new FixtureAttribute with the name given" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including)
    FixtureReplacement.attributes_for(:foo, {}) 
  end
  
  it "should create a new FixtureAttribute with the name given and class given" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including(:class => Object))
    FixtureReplacement.attributes_for(:foo, {:class => Object})
  end
  
  it "should create a new FixtureAttribute with the name given and the attributes from the block" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including(:from => :bar))
    FixtureReplacement.attributes_for(:foo, {:from => :bar})
  end
  
  it "should not raise an error if no block is given" do
    lambda {
      FixtureReplacement.attributes_for :scott, :from => :user  
    }.should_not raise_error
  end
end
