require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement, "attributes_for" do
  before :each do
    @fixture_attribute = FixtureReplacementController::AttributeCollection
    @fixture_attribute.stub!(:new)
    
    @attributes_proc = lambda {}
    Kernel.stub!(:lambda).and_return @attributes_proc
  end
  
  it "should take a fixture name" do
    FixtureReplacement.attributes_for(:foo) {}
  end
  
  it "should take a fixture name along with a hash of attributes" do
    FixtureReplacement.attributes_for(:foo, :bar => :baz, :baz => :zed) {}
  end
  
  it "should create a new FixtureAttribute with the name given" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including)
    FixtureReplacement.attributes_for(:foo, {}, &@attributes_proc) 
  end
  
  it "should create a new FixtureAttribute with the name given and class given" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including(:class => Object))
    FixtureReplacement.attributes_for(:foo, {:class => Object}, &@attributes_proc)
  end
  
  it "should create a new FixtureAttribute with the name given and the attributes from the block" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including(:from => :bar))
    FixtureReplacement.attributes_for(:foo, {:from => :bar}, &@attributes_proc)
  end
  
  it "should create a new FixtureAttribute with the name and block given" do
    @fixture_attribute.should_receive(:new).with(:foo, hash_including(:attributes => @attributes_proc))
    FixtureReplacement.attributes_for(:foo, {}, &@attributes_proc)
  end
end

describe "FixtureReplacement.attributes_for" do
  it "should not raise an error if no block is given" do
    lambda {
      FixtureReplacement.attributes_for :scott, :from => :user  
    }.should_not raise_error
  end
  
  it "should create a new Attribute with the class, attributes_from, and the attributes as a lambda" do
    @proc = lambda { |os| }
    Kernel.stub!(:lambda).and_return @proc
    FixtureReplacementController::AttributeCollection.stub!(:new)
    FixtureReplacementController::AttributeCollection.should_receive(:new).with(:scott, {
      :class => User,
      :from => :user,
      :attributes => @proc
    })

    FixtureReplacement.attributes_for(:scott, :from => :user, :class => User, &@proc)
  end  
end