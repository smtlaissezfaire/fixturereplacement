require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacement
  module Controller
    describe "MethodGenerator.generate_methods" do
      before :each do
        @attributes = mock AttributeCollection
        AttributeCollection.stub!(:instances).and_return [@attributes]
        @method_generator = mock MethodGenerator
        @method_generator.stub!(:generate_methods)
        MethodGenerator.stub!(:new).and_return @method_generator
      end    
    
      it "should find each of the attributes" do
        AttributeCollection.should_receive(:instances).and_return [@attributes]
        MethodGenerator.generate_methods
      end
    
      it "should create a new MethodGenerator for each attribute" do
        MethodGenerator.should_receive(:new).with(@attributes).and_return @method_generator
        MethodGenerator.generate_methods
      end
    
      it "should generate the methods for each new MethodGenerator created" do
        @method_generator.should_receive(:generate_methods)
        MethodGenerator.generate_methods
      end
    end  
  
    describe MethodGenerator, "generate_methods (the instance method)" do
      before :each do
        @attributes = mock 'AttributeCollection'
      
        @generator = MethodGenerator.new(@attributes)
        @generator.stub!(:generate_default_method)
        @generator.stub!(:generate_new_method)
        @generator.stub!(:generate_create_method)
      end
    
      it "should generate the default method" do
        @generator.should_receive(:generate_default_method)
        @generator.generate_methods
      end
    
      it "should generate the new method" do
        @generator.should_receive(:generate_new_method)
        @generator.generate_methods
      end
    
      it "should generate the create method" do
        @generator.should_receive(:generate_create_method)
        @generator.generate_methods
      end
    end  
  end
end