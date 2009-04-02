require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "default_method" do
    it "should create a proc" do
      @obj = use_module do
        attributes_for :user
      end
      
      @obj.default_user.should be_a_kind_of(Proc)
    end
    
    it "should instantiate a new instance of the class when calling the proc generated" do
      @obj = use_module do
        attributes_for :user do |u|
          u.key = :foo
        end
      end
      
      @obj.default_user.call.should be_a_kind_of(User)
    end
    
    it "should create the object" do
      @context = use_module do
        attributes_for :user do |u|
          u.key = :foo
        end
      end
      
      obj = @context.default_user.call
      obj.should_not be_a_new_record
    end
  end
end