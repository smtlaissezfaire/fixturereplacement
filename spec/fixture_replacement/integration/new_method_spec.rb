require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "the new_* method" do
    it "should be a user for attributes_for :user" do
      obj = use_module do
        attributes_for :user
      end

      obj.new_user.should be_a_kind_of(User)
    end

    it "should use the given class" do
      obj = use_module do
        attributes_for :foo, :class => User
      end

      obj.new_foo.should be_a_kind_of(User)
    end

    it "should find the correct class name" do
      obj = use_module do
        attributes_for :admin
      end

      obj.new_admin.should be_a_kind_of(Admin)
    end

    it "should return a new object with the keys given in user_attributes" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end

      obj.new_user.key.should == "val"
    end

    it "should over-write the User's hash with any hash given to new_user" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end

      obj.new_user(:key => "other_value").key.should == "other_value"
    end

    it "should add any hash key-value pairs which weren't previously given in user_attributes" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end

      user = obj.new_user(:other_key => "other_value")
      user.key.should == "val"
      user.other_key.should == "other_value"
    end

    it "should not be saved to the database" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end

      obj.new_user.should be_a_new_record
    end

    it "should be able to be saved to the database" do
      obj = use_module do
        attributes_for :user do |u|
          u.key = "val"
        end
      end

      lambda {
        obj.new_user.save!
      }.should_not raise_error
    end

    it "should yield the object inside the block" do
      obj = nil

      mod = use_module do
        attributes_for :user do |u|
          obj = u
        end
      end

      mod.new_user # trigger the block
      obj.should be_a_kind_of(User)
    end
  end
end
