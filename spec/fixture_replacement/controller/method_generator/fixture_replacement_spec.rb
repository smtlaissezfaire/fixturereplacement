require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacementController
  describe "MethodGenerator.generate_methods" do
    before :each do
      @attributes = mock AttributeCollection
      AttributeCollection.stub!(:instances).and_return [@attributes]
      @module = mock "A Module"
      @method_generator = mock MethodGenerator
      @method_generator.stub!(:generate_methods)
      MethodGenerator.stub!(:new).and_return @method_generator
    end    
    
    it "should find each of the attributes" do
      AttributeCollection.should_receive(:instances).and_return [@attributes]
      MethodGenerator.generate_methods(@module)
    end
    
    it "should create a new MethodGenerator for each attribute" do
      MethodGenerator.should_receive(:new).with(@attributes, @module).and_return @method_generator
      MethodGenerator.generate_methods(@module)
    end
    
    it "should generate the methods for each new MethodGenerator created" do
      @method_generator.should_receive(:generate_methods)
      MethodGenerator.generate_methods(@module)
    end
  end
end
