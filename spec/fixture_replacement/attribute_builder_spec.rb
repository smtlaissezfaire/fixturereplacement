require File.dirname(__FILE__) + "/../spec_helper"

module FixtureReplacement
  describe AttributeBuilder do  
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
      AttributeBuilder.new(:bar, :from => :foo).active_record_class.should == Object      
    end    
    
    it "should not raise an error if the model ends with 's'" do
      AttributeBuilder.new(:actress).active_record_class.should == Actress
    end
  end  
  
  describe AttributeBuilder, "hash, with simple arguments (only attributes and fixture name)" do
    
    it "should return a hash" do
      AttributeBuilder.new(:foo).to_hash.should == {}
    end
    
    it "should return the attributes hash given" do
      attributes = AttributeBuilder.new(:foo) do |f|
        f.foo = :bar
        f.scott = :taylor
      end
      
      attributes.to_hash.should == {
        :foo => :bar,
        :scott => :taylor
      }
    end
  end
  
  module AttributeFromHelper
    def setup_attributes
      @from_attributes = AttributeBuilder.new(:foo) do |u|
        u.first_name = :scott
      end
    end
  end
  
  describe AttributeBuilder, "with an empty hash, after merge with another inherited attribute" do    
    include AttributeFromHelper
    
    before :each do
      setup_attributes
      @attributes = AttributeBuilder.new(:bar, :from => :foo)
    end
    
    it "should contain the keys from the inherited hash only" do
      @attributes.to_hash.should == {
        :first_name => :scott
      }
    end
  end
  
  describe AttributeBuilder, "with a hash, after merge with another inherited attributes" do
    include AttributeFromHelper
    
    before :each do
      setup_attributes      
    end
    
    it "should overwrite an attribute" do
      attributes = AttributeBuilder.new :bar, :from => :foo do |u|
        u.first_name = :scott
      end
      
      attributes.to_hash.should == {:first_name => :scott}
    end
    
    it "should keep any new attributes, as well as any attributes which weren't overwritten" do
      attributes = AttributeBuilder.new(:bar, :from => :foo) do |os|
        os.foo = :bar
      end
      
      attributes.to_hash.should == {:foo => :bar, :first_name => :scott}      
    end
  end  
end
