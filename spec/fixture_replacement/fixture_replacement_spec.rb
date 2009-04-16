require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement do
  before do
    FixtureReplacement.reset!
  end

  after do
    FixtureReplacement.reset!
  end

  it "should have create as the default" do
    FixtureReplacement.create_dependent_objects?.should be_true
  end

  it "should be able to set dependent object creation" do
    FixtureReplacement.create_dependent_objects = false
    FixtureReplacement.create_dependent_objects?.should be_false
  end

  it "should have the default_method as :create when create_dependent_objects?" do
    FixtureReplacement.create_dependent_objects = true
    FixtureReplacement.default_method.should equal(:create)
  end

  it "should have the default_method as :new when create_dependent_objects == false" do
    FixtureReplacement.create_dependent_objects = false
    FixtureReplacement.default_method.should equal(:new)
  end
  
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
      FixtureReplacement.stub!(:load)
    end

    it "should require db/example_data" do
      FixtureReplacement.stub!(:rails_root).and_return "/foo/bar"
      FixtureReplacement.should_receive(:load).with("/foo/bar/db/example_data.rb")

      FixtureReplacement.load_example_data
    end

    it "should use the correct rails root" do
      FixtureReplacement.stub!(:rails_root).and_return "/rails/root"
      FixtureReplacement.should_receive(:load).with("/rails/root/db/example_data.rb")

      FixtureReplacement.load_example_data
    end

    it "should not blow up if the file is not found" do
      FixtureReplacement.stub!(:load).and_raise LoadError

      lambda {
        FixtureReplacement.load_example_data
      }.should_not raise_error
    end
  end

  describe "rails_root" do
    def use_rails_root(rails_root, &block)
      silence_warnings do
        Object.const_set(:RAILS_ROOT, rails_root)
      end
      block.call
    ensure
      Object.send :remove_const, :RAILS_ROOT
    end

    it "should be the RAILS_ROOT constant if given" do
      use_rails_root "/rails/root" do
        FR.rails_root.should == "/rails/root"
      end
    end

    it "should use the correct RAILS_ROOT" do
      use_rails_root "/foo/bar" do
        FR.rails_root.should == "/foo/bar"
      end
    end

    it "should be '.' if not defined" do
      FR.rails_root.should == "."
    end
  end
end
