require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "With a public, user defined method" do
    before do
      @obj = use_module do
        attributes_for :user_with_a_public_method, :class => User do |u|
          u.key = a_public_method
        end
        
        def a_public_method
          :public
        end
      end
    end
    
    it "should be able to call it" do
      user = @obj.new_user_with_a_public_method
      user.key.should == :public
    end
  end
  
  describe "With a private, user defined method" do
    before do
      @obj = use_module do
        attributes_for :user_with_a_private_method, :class => User do |u|
          u.key = a_private_method
        end
        
      private
        
        def a_private_method
          :private
        end
      end
    end
    
    it "should be able to call it" do
      user = @obj.new_user_with_a_private_method
      user.key.should == :private
    end
  end
end