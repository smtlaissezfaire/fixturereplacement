require File.dirname(__FILE__) + "/../spec_helper"

module FixtureReplacement
  describe AttributeBuilder do
    before do
      AttributeBuilder.clear_out_instances!
    end

    it "should add the instance to the global attributes" do
      a = AttributeBuilder.new(:foo)
      AttributeBuilder.instances.should == [a]
    end

    it "should have no instances when none have been created" do
      AttributeBuilder.instances.should == []
    end

    it "should have two instances when two have been created" do
      a1 = AttributeBuilder.new(:foo)
      a2 = AttributeBuilder.new(:foo)
      AttributeBuilder.instances.should == [a1, a2]
    end

    it "should have the fixture name as accessible" do
      a1 = AttributeBuilder.new(:foo)
      a1.fixture_name.should == :foo
    end

    it "should have the from attribute as nil, if none provided" do
      a1 = AttributeBuilder.new(:foo)
      a1.from.should be_nil
    end

    it "should have the from attribute as the symbol of the attribute from which it derives" do
      a1 = AttributeBuilder.new(:foo, :from => :bar)
      a1.from.should == :bar
    end

    it "should be able to find the Attribute by fixture name" do
      a = AttributeBuilder.new(:baz)
      AttributeBuilder.find_by_fixture_name(:baz).should == a
    end

    it "should find no attributes for fixture_name :baz, if it was never created" do
      a = AttributeBuilder.new(:bar)
      AttributeBuilder.find_by_fixture_name(:baz).should be_nil
    end

    it "should find no attributes for fixture_name :baz, if no fixture at all was ever created" do
      AttributeBuilder.find_by_fixture_name(:baz).should be_nil
    end

    it "should have the class name if specified" do
      AttributeBuilder.new(:foo, :class => Object).active_record_class.should == Object
    end

    it "should use the class name of the fixture_name, camel-cased, if the class is unspecified, and the fixture uninherited" do
      AttributeBuilder.new(:object).active_record_class.should == Object
    end

    it "should use the class name of the inherited attribute, if specified" do
      AttributeBuilder.new(:foo, :class => Object)
      AttributeBuilder.new(:bar, :from => :foo).active_record_class.should == Bar
    end

    it "should prefer the constantized name to the derived name" do
      AttributeBuilder.new(:user)
      AttributeBuilder.new(:admin, :from => :user).active_record_class.should == Admin
    end

    it "should use the derived name if the constantized name fails (doesn't exist)" do
      AttributeBuilder.new(:foo)
      no_constant = AttributeBuilder.new(:no_constant, :from => :foo)
      no_constant.active_record_class.should == Foo
    end

    it "should raise a name error if it has no class, the name can't be constantized, and is derived, but the derived class can't be constantized" do
      builder_one = AttributeBuilder.new(:does_not_exist)
      builder_two = AttributeBuilder.new(:also_does_not_exist, :from => :does_not_exist)

      lambda {
        builder_two.active_record_class
      }.should raise_error(NameError)
    end

    it "should not raise an error if the model ends with 's'" do
      AttributeBuilder.new(:actress).active_record_class.should == Actress
    end

    it "should allow a string key" do
      AttributeBuilder.new(:admin, "from" => :user).active_record_class.should == Admin
    end

    it "should allow a string name for the builder" do
      AttributeBuilder.new("admin").active_record_class.should == Admin
    end

    it "should store the from key as a symbol, even when passed a string" do
      builder = AttributeBuilder.new(:admin, "from" => "user")
      builder.from.should == :user
    end

    it "should convert the fixture name to a symbol" do
      builder = AttributeBuilder.new("admin")
      builder.fixture_name.should == :admin
    end

    describe "validating all instances" do
      it "should return true if there are no instances" do
        AttributeBuilder.validate_instances!.should be_true
      end

      it "should raise an error if an instance is not valid" do
        AttributeBuilder.new(:validate_name)

        lambda {
          AttributeBuilder.validate_instances!
        }.should raise_error
      end

      it "should not raise an error if there is only one instance, and it is valid" do
        AttributeBuilder.new(:event)

        lambda {
          AttributeBuilder.validate_instances!
        }.should_not raise_error
      end

      it "should raise an error, giving the fixture name, and the error" do
        AttributeBuilder.new(:validate_name)

        lambda {
          AttributeBuilder.validate_instances!
        }.should raise_error(FixtureReplacement::InvalidInstance, "new_validate_name is not valid! - Errors: [name: can't be blank]")
      end

      it "should use the correct name" do
        AttributeBuilder.new(:validate_name_two)

        lambda {
          AttributeBuilder.validate_instances!
        }.should raise_error(FixtureReplacement::InvalidInstance, "new_validate_name_two is not valid! - Errors: [name: can't be blank]")
      end

      it "should use the correct errors" do
        AttributeBuilder.new(:address_with_valid_city)

        lambda {
          AttributeBuilder.validate_instances!
        }.should raise_error(FixtureReplacement::InvalidInstance, "new_address_with_valid_city is not valid! - Errors: [city: can't be blank]")
      end

      it "should use multiple errors on a single model" do
        AttributeBuilder.new(:address_with_valid_city_and_state)

        lambda {
          AttributeBuilder.validate_instances!
        }.should raise_error(FixtureReplacement::InvalidInstance, "new_address_with_valid_city_and_state is not valid! - Errors: [city: can't be blank], [state: can't be blank]")
      end
    end
  end
end
