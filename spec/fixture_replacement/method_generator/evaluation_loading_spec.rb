require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe MethodGenerator, "Evaluation loading" do
    it "should not raise an error if the a default_* method is referenced before it is defined" do
      lambda {
        use_module do
          attributes_for :item do |o|
            o.category = default_category
          end
        end
      }.should_not raise_error
    end 
  end
end