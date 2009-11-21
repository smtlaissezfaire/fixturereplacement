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
          x.key = 17
        end
      end

      obj.valid_user_attributes.should include({ "key" => 17 })
    end

    it "should have the attributes given" do
      obj = use_module do
        attributes_for :user do |x|
          x.key = 18
        end
      end

      obj.valid_user_attributes.should include({ "key" => 18 })
    end
  end
end
