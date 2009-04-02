require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  before do
    @klass = Class.new
    FixtureReplacement::MethodGenerator.stub!(:generate_methods)
  end
  
  it "should generate the methods when included inside the FixtureReplacement module" do
    FixtureReplacement::MethodGenerator.stub!(:generate_methods)
    FixtureReplacement::MethodGenerator.should_receive(:generate_methods).with(FixtureReplacement)
    
    @klass.class_eval do
      include FixtureReplacement
    end
  end
  
  it "should not generate the methods before being included" do
    FixtureReplacement::MethodGenerator.should_not_receive(:generate_methods)
    
    @klass.instance_methods.should_not include("create_user")
    @klass.instance_methods.should_not include("new_user")
    @klass.instance_methods.should_not include("default_user")
  end
  
  it "should generate the methods when extending" do
    obj = Object.new
    FixtureReplacement::MethodGenerator.should_receive(:generate_methods)
    obj.extend FixtureReplacement
  end
end