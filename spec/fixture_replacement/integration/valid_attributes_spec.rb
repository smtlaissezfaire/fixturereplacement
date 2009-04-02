require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "valid_*_attributes" do
    it "should generate the method valid_user_attributes when attributes_for is specified" do
      obj = use_module do
        attributes_for :user
      end
      
      obj.should respond_to(:valid_user_attributes)
    end
    
    it "should generate the method valid_member_attributes when attributes_for is specified" do
      obj = use_module do
        attributes_for :member
      end
      
      obj.should respond_to(:valid_member_attributes)
    end
    
    it "should have the attributes given as a hash" do
      obj = use_module do
        attributes_for :user do |x|
          x.foo = 17
        end
      end
      
      obj.valid_user_attributes.should == {
        :foo => 17
      }
    end
    
    it "should have the attributes given" do
      obj = use_module do
        attributes_for :user do |x|
          x.bar = 18
        end
      end
      
      obj.valid_user_attributes.should == {
        :bar => 18
      }
    end
    
    it "should have a lambda for a default_* call" do
      obj = use_module do
        attributes_for :user do |x|
          x.first_name = "scott"
        end
        
        attributes_for :post do |x|
          x.user = default_user
        end
      end
      
      obj.valid_post_attributes[:user].should be_a_kind_of(Proc)
    end
  end
end