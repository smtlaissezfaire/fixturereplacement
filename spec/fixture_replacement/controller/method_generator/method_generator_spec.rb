require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacementController
  describe MethodGenerator do
    before :each do
      @user_attributes = mock("UserAttributes")
      @user_attributes.stub!(:merge!)
      @module = mock("FixtureReplacement")
      @generator = MethodGenerator.new(@user_attributes, @module)
    end
    
    it "should have the class method generate_methods" do
      MethodGenerator.should respond_to(:generate_methods)
    end
        
    it "should not raise an error if the model ends with 's'" do
      pending "Is this some weird regression I need to fix, again?"
    end

    it "should be able to respond to generate_default_method" do
      @generator.should respond_to(:generate_default_method)
    end

    it "should respond to generate_create_method" do
      @generator.should respond_to(:generate_create_method)
    end

    it "should respond to generate_new_method" do
      @generator.should respond_to(:generate_new_method)
    end
  end
end