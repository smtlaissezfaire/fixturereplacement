require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  describe "random_string" do
    before do
      @fr = FixtureReplacement
    end

    it "should not be the same as another randomly generated string" do
      @fr.random_string.should_not == @fr.random_string
    end

    it "should by default be 10 characters long" do
      @fr.random_string.size.should == 10
    end

    it "should be able to specify the length of the random string" do
      @fr.random_string(100).size.should == 100
    end

    it "should only generate lowercase letters" do
      s = @fr.random_string(100)
      s.upcase.should == s.swapcase
    end
  end

  describe "requiring the fixtures file" do
    before do
      FixtureReplacement.stub(:load)
    end

    it "should require db/example_data" do
      FixtureReplacement.stub(:rails_root).and_return "/foo/bar"
      FixtureReplacement.should_receive(:load).with("/foo/bar/db/example_data.rb")

      FixtureReplacement.load!
    end

    it "should use the correct rails root" do
      FixtureReplacement.stub(:rails_root).and_return "/rails/root"
      FixtureReplacement.should_receive(:load).with("/rails/root/db/example_data.rb")

      FixtureReplacement.load!
    end

    it "should not blow up if the file is not found" do
      FixtureReplacement.stub(:load).and_raise LoadError

      lambda {
        FixtureReplacement.load!
      }.should_not raise_error
    end
  end

  describe "reload!" do
    it "should call load on the main fixture replacement file" do
      file_path = File.expand_path(File.dirname(__FILE__) + "/../../lib/fixture_replacement.rb")
      FixtureReplacement.should_receive(:load).with(file_path)

      FixtureReplacement.reload!
    end
  end
end
