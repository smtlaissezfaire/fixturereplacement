require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "keys passed to attributes for" do
    it "should raise an invalid key error when an invalid key is passed" do
      lambda {
        use_module do
          attributes_for :user, :class_name => "foo"
        end
      }.should raise_error(FixtureReplacement::AttributeBuilder::InvalidKeyError,
                          ":class_name is not a valid option to attributes_for.  Valid keys are: [:from, :class]")
    end
  end
end
