require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  it "should have the method attributes_for" do
    FixtureReplacement.should respond_to(:attributes_for)
  end
end

describe FixtureReplacement, "attributes_for" do
  before :each do
    @fixture_attribute = mock "FixtureAttribute"
    @fixture_attribute.stub!(:new)
  end
  
  it "should take a fixture name" do
    FixtureReplacement.attributes_for(:foo) {}
  end
  
  it "should take a fixture name along with a hash of attributes" do
    FixtureReplacement.attributes_for(:foo, :bar => :baz, :baz => :zed) {}
  end
  
  it "should create a new FixtureAttribute with the name given" do
    @fixture_attribute.should_receive(:new).with(:foo, {:class => nil, :from => nil, :attributes => OpenStruct.new})
    FixtureReplacement.attributes_for(:foo, {}, @fixture_attribute) {  }
  end
  
  it "should create a new FixtureAttribute with the name given and class given" do
    @fixture_attribute.should_receive(:new).with(:foo, {:class => Object, :from => nil, :attributes => OpenStruct.new})
    FixtureReplacement.attributes_for(:foo, {:class => Object}, @fixture_attribute) { }  
  end
  
  it "should create a new FixtureAttribute with the name given and the attributes from" do
    @fixture_attribute.should_receive(:new).with(:foo, {:class => nil, :from => :bar, :attributes => OpenStruct.new})
    FixtureReplacement.attributes_for(:foo, {:from => :bar}, @fixture_attribute) { }
  end
  
  it "should create a new FixtureAttribute with the name and block given" do
    @ostruct = OpenStruct.new
    @ostruct.bar = :baz
    @fixture_attribute.should_receive(:new).with(:foo, {:class => nil, :from => nil, :attributes => @ostruct})
    FixtureReplacement.attributes_for(:foo, {}, @fixture_attribute) do |foo|
      foo.bar = :baz
    end
  end
end