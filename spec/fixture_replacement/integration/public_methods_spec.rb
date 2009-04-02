require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "including methods" do
    it "should have the create_user method as public" do
      obj = use_module do
        attributes_for :user
      end
      
      obj.public_methods.should include("create_user")
    end
    
    it "should respond_to? create_user" do
      obj = use_module do
        attributes_for :user
      end

      obj.respond_to?(:create_user).should be_true
    end
  end
end