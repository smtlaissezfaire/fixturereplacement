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
          x.key = "some string"
        end
      end

      obj.valid_user_attributes.should include({ "key" => "some string" })
    end

    it "should have the attributes given" do
      obj = use_module do
        attributes_for :user do |x|
          x.key = "some other string"
        end
      end

      obj.valid_user_attributes.should include({ "key" => "some other string" })
    end
  end
end
