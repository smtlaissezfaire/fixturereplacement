require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "the create_* method" do
    it "should be a user for attributes_for :user" do
      obj = use_module do
        attributes_for :user
      end
      
      obj.create_user.should be_a_kind_of(User)
    end
    
    it "should use the given class" do
      obj = use_module do
        attributes_for :foo, :class => User
      end
      
      obj.create_foo.should be_a_kind_of(User)
    end
    
    it "should evaluate any of the default_* methods before returning (if no over-writing key is given)" do
      obj = use_module do
        attributes_for :gender do |g|
          g.sex = "Male"
        end
        
        attributes_for :user do |u|
          u.gender = default_gender
        end
      end
      
      obj.create_user.gender.sex.should == "Male"
    end
    
    it "should find the correct class name" do
      obj = use_module do
        attributes_for :admin
      end
      
      obj.create_admin.should be_a_kind_of(Admin)
    end
        
    it "should over-write the User's hash with any hash given to create_user" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end
      
      obj.create_user(:key => "other_value").key.should == "other_value"
    end
    
    it "should add any hash key-value pairs which weren't previously given in user_attributes" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end
      
      user = obj.create_user(:other_key => "other_value")
      user.key.should == "val"
      user.other_key.should == "other_value"
    end
        
    it "should not be saved to the database" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end
      
      obj.create_user.should_not be_a_new_record
    end
  end
end