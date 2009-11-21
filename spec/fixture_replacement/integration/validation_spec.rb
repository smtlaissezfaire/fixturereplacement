require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

module FixtureReplacement
  describe "validations" do
    it "should not raise with a record that has no validations" do
      fr = mock_fr_module do
        attributes_for :no_validation do
        end
      end

      lambda {
        fr.validate!
      }.should_not raise_error
    end

    it "should raise an error when the record is not valid" do
      fr = mock_fr_module do
        attributes_for :validate_name
      end

      lambda {
        fr.validate!
      }.should raise_error
    end

    it "should not raise if the record is valid" do
      fr = mock_fr_module do
        attributes_for :validate_name do |n|
          n.name = "Scott"
        end
      end

      lambda {
        fr.validate!
      }.should_not raise_error
    end

    it "should not raise if first loaded with an invalid record, and later a valid one after reloading" do
      fr = mock_fr_module do
        attributes_for :validate_name
      end

      fr.reload!

      fr.attributes_for :validate_name do |n|
        n.name = "Scott"
      end

      lambda {
        fr.validate!
      }.should_not raise_error
    end
  end
end
