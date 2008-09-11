require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe UndefinedValue do
    it "should be a kind of class" do
      UndefinedValue.should be_a_kind_of(Class)
    end
  end
end
