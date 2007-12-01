require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe Attributes do  
    after :each do
      Attributes.clear_out_instances!
    end
    
    it "should add the instance to the global attributes" do
      a = Attributes.new(:foo)
      Attributes.instances.should == [a]
    end
    
    it "should have no instances when none have been created" do
      Attributes.instances.should == []
    end
    
    it "should have two instances when two have been created" do
      a1 = Attributes.new(:foo)
      a2 = Attributes.new(:foo)
      Attributes.instances.should == [a1, a2]
    end
    
    it "should have the fixture name as accessible" do
      a1 = Attributes.new(:foo)
      a1.fixture_name.should == :foo
    end
    
    it "should have the from attribute as nil, if none provided" do
      a1 = Attributes.new(:foo)
      a1.from.should be_nil
    end
    
    it "should have the from attribute as the symbol of the attribute from which it derives" do
      a1 = Attributes.new(:foo, :from => :bar)
      a1.from.should == :bar
    end
    
    it "should be able to find the Attribute by fixture name" do
      a = Attributes.new(:baz)
      Attributes.find_by_fixture_name(:baz).should == a
    end
    
    it "should find no attributes for fixture_name :baz, if it was never created" do
      a = Attributes.new(:bar)
      Attributes.find_by_fixture_name(:baz).should be_nil
    end
    
    it "should find no attributes for fixture_name :baz, if no fixture at all was ever created" do
      Attributes.find_by_fixture_name(:baz).should be_nil
    end
    
    it "should have the class name if specified" do
      Attributes.new(:foo, :class => Object).of_class.should == Object
    end
    
    it "should use the class name of the fixture_name, camel-cased, if the class is unspecified, and the fixture uninherited" do
      Attributes.new(:object).of_class.should == Object
    end
    
    it "should use the class name of the inherited attribute, if specified" do
      Attributes.new(:foo, :class => Object)
      Attributes.new(:bar, :from => :foo).of_class.should == Object      
    end    
  end  
  
  describe Attributes, "hash, with simple arguments (only attributes and fixture name)" do
    
    after :each do
      Attributes.clear_out_instances!
    end
    
    it "should return a hash" do
      Attributes.new(:foo).hash.should == {}
    end
    
    it "should return the attributes hash given" do
      @struct = OpenStruct.new
      @struct.foo = :bar
      @struct.scott = :taylor
      Attributes.new(:foo, :attributes => @struct).hash.should == {
        :foo => :bar,
        :scott => :taylor
      }
    end
  end
  
  module AttributeFromHelper
    def setup_attributes
      @from_attributes_as_struct = OpenStruct.new({:first_name => :scott})
      @from_attributes = Attributes.new(:foo, :attributes => @from_attributes_as_struct)
    end
  end
  
  describe Attributes, "with an empty hash, after merge with another inherited attribute" do    
    include AttributeFromHelper
    
    before :each do
      setup_attributes
      @attributes = Attributes.new(:bar, :from => :foo)
    end
    
    after :each do
      Attributes.clear_out_instances!
    end

    it "should contain the keys from the inherited hash only" do
      @attributes.merge!
      @attributes.hash.should == {
        :first_name => :scott
      }
    end
  end
  
  describe Attributes, "with a hash, after merge with another inherited attributes" do
    include AttributeFromHelper
    
    before :each do
      setup_attributes      
    end
    
    after :each do
      Attributes.clear_out_instances!
    end
    
    it "should overwrite an attribute" do
      open_struct = OpenStruct.new({:first_name => :scott})
      
      attributes = Attributes.new :bar, :from => :foo, :attributes => open_struct
      
      attributes.merge!
      attributes.hash.should == {:first_name => :scott}
    end
    
    it "should keep any new attributes, as well as any attributes which weren't overwritten" do
      open_struct = OpenStruct.new({:foo => :bar})
      
      attributes = Attributes.new(:bar, :from => :foo, :attributes => open_struct)
      
      attributes.merge!
      attributes.hash.should == {:foo => :bar, :first_name => :scott}      
    end
  end  
end
