require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  module Controller
    describe AttributeCollection do  
      it "should add the instance to the global attributes" do
        a = AttributeCollection.new(:foo)
        AttributeCollection.instances.should == [a]
      end
    
      it "should have no instances when none have been created" do
        AttributeCollection.instances.should == []
      end
    
      it "should have two instances when two have been created" do
        a1 = AttributeCollection.new(:foo)
        a2 = AttributeCollection.new(:foo)
        AttributeCollection.instances.should == [a1, a2]
      end
    
      it "should have the fixture name as accessible" do
        a1 = AttributeCollection.new(:foo)
        a1.fixture_name.should == :foo
      end
    
      it "should have the from attribute as nil, if none provided" do
        a1 = AttributeCollection.new(:foo)
        a1.from.should be_nil
      end
    
      it "should have the from attribute as the symbol of the attribute from which it derives" do
        a1 = AttributeCollection.new(:foo, :from => :bar)
        a1.from.should == :bar
      end
    
      it "should be able to find the Attribute by fixture name" do
        a = AttributeCollection.new(:baz)
        AttributeCollection.find_by_fixture_name(:baz).should == a
      end
    
      it "should find no attributes for fixture_name :baz, if it was never created" do
        a = AttributeCollection.new(:bar)
        AttributeCollection.find_by_fixture_name(:baz).should be_nil
      end
    
      it "should find no attributes for fixture_name :baz, if no fixture at all was ever created" do
        AttributeCollection.find_by_fixture_name(:baz).should be_nil
      end
    
      it "should have the class name if specified" do
        AttributeCollection.new(:foo, :class => Object).active_record_class.should == Object
      end
    
      it "should use the class name of the fixture_name, camel-cased, if the class is unspecified, and the fixture uninherited" do
        AttributeCollection.new(:object).active_record_class.should == Object
      end
    
      it "should use the class name of the inherited attribute, if specified" do
        AttributeCollection.new(:foo, :class => Object)
        AttributeCollection.new(:bar, :from => :foo).active_record_class.should == Object      
      end    
    
      it "should not raise an error if the model ends with 's'" do
        AttributeCollection.new(:actress).active_record_class.should == Actress
      end
    
      it "should allow instances to created with strings, and still found" do
        obj = AttributeCollection.new("foo")
        AttributeCollection.find_by_fixture_name(:foo).should == obj
      end
    
      it "should allow instances to be found with a string" do
        obj = AttributeCollection.new(:foo)
        AttributeCollection.find_by_fixture_name("foo").should == obj
      end
    
      it "should use a symbol for the fixture name" do
        AttributeCollection.new(:bar)
        obj = AttributeCollection.new(:foo, :from => "bar")
        obj.from.should == :bar
      end
    
      it "should raise an UnknownFixture error if deriving from a fixture which is not around" do
        obj = AttributeCollection.new(:foo, :from => :baz)
        lambda {
          obj.to_hash
        }.should raise_error(FixtureReplacement::UnknownFixture, "The fixture definition for `baz` cannot be found")
      end
    
      it "should raise an UnknownFixture error if deriving from a fixture which is not around with the correct name" do
        obj = AttributeCollection.new(:foo, :from => :bar)
        lambda {
          obj.to_hash
        }.should raise_error(FixtureReplacement::UnknownFixture, "The fixture definition for `bar` cannot be found")
      end
    end  
  
    describe AttributeCollection, "hash, with simple arguments (only attributes and fixture name)" do
    
      it "should return a hash" do
        AttributeCollection.new(:foo).hash.should == {}
      end
    
      it "should return the attributes hash given" do
        @struct = OpenStruct.new
        @struct.foo = :bar
        @struct.scott = :taylor
        attributes = AttributeCollection.new(:foo, :attributes => lambda do |f|
          f.foo = :bar
          f.scott = :taylor
        end)
      
        attributes.hash.should == {
          :foo => :bar,
          :scott => :taylor
        }
      end
    end
  
    describe "to_hash" do
      it "should be an empty hash when not derived" do
        AttributeCollection.new(:foo).to_hash.should == { }
      end
    
      it "should be the set of attributes" do
        ac = AttributeCollection.new(:foo, :attributes => lambda { |obj| obj.baz = :quxx })
        ac.to_hash.should == { :baz => :quxx }
      end
    
      it "should be the hash of the derived fixture" do
        AttributeCollection.new(:foo, :attributes => lambda { |obj| obj.bar = :quxx })
        obj = AttributeCollection.new(:bar, :from => :foo)
        obj.to_hash.should == { :bar => :quxx }
      end
    
      it "should use attributes from both fixtures" do
        first_attribute_set = lambda { |obj| obj.foo = :bar }
        second_attribute_set = lambda { |obj| obj.bar = :baz }
      
        AttributeCollection.new(:foo, :attributes => first_attribute_set)
        obj = AttributeCollection.new(:bar, :from => :foo, :attributes => second_attribute_set)
        obj.to_hash.should == { :foo => :bar, :bar => :baz }
      end
    
      it "should prefer merge the attributes, prefering newer attributes" do
        first_attribute_set = lambda { |obj| obj.foo = :one }
        second_attribute_set = lambda { |obj| obj.foo = :two }
      
        AttributeCollection.new(:foo, :attributes => first_attribute_set)
        obj = AttributeCollection.new(:bar, :from => :foo, :attributes => second_attribute_set)
        obj.to_hash.should == { :foo => :two }
      end
    
      it "should derive two fixtures down" do
        first_attribute_set = lambda { |obj| obj.foo = :one }
      
        AttributeCollection.new(:foo, :attributes => first_attribute_set)
        AttributeCollection.new(:bar, :from => :foo)
        obj = AttributeCollection.new(:baz, :from => :bar)
      
        obj.to_hash.should == { :foo => :one }
      end
    
      it "should have the hash method as an alias to the to_hash method" do
        obj = AttributeCollection.new(:bar)
        obj.method(:hash).should == obj.method(:to_hash)
        obj.method(:to_hash).should == obj.method(:hash)
      end
    
      describe "finding a fixture by name" do
        it "should return nil if it cannot find the fixture" do
          AttributeCollection.find_by_fixture_name(:foo_bar).should be_nil
        end
      
        it "should return nil if the object passed is a PORL" do
          object = Object.new
          AttributeCollection.find_by_fixture_name(object).should be_nil
        end
      end
    end
  end
end