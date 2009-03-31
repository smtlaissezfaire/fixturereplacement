require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe AttributeBuilder do
    before :each do
      lambda_expression = nil
      
      @module = Module.new do
        extend FixtureReplacement::ClassMethods

        lambda_expression = lambda { |o|
          o.bar = a_method
          o.baz = a_baz_method
        }
        
        def a_method
          :bar
        end
        
        def a_baz_method
          :baz
        end
      end

      @attributes = AttributeBuilder.new(:foo, &lambda_expression)
    end
    
    it "should evaluate the proc in the binding of the caller which is passed" do
      @attributes.to_hash[:bar].should == :bar
    end
    
    it "should get the correct value for the method called" do
      @attributes.to_hash[:baz].should == :baz
    end
  end
end