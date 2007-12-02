require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacementController
  describe "MethodGenerator.generate_methods" do
    before :each do
      @attributes = mock Attributes
      Attributes.stub!(:instances).and_return [@attributes]
      @module = mock "A Module"
      @method_generator = mock MethodGenerator
      @method_generator.stub!(:generate_methods)
      MethodGenerator.stub!(:new).and_return @method_generator
    end    
    
    it "should use the FixtureReplacement module if none provided" do
      MethodGenerator.module.should == FixtureReplacement
    end
    
    it "should take an optional module name" do
      MethodGenerator.generate_methods(@module)
    end  
    
    it "should use the module if given one specifically" do
      MethodGenerator.generate_methods(@module)
      MethodGenerator.module.should == @module
    end
    
    it "should find each of the attributes" do
      Attributes.should_receive(:instances).and_return [@attributes]
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
  
  describe MethodGenerator, "generate_methods (the instance method)" do
    before :each do
      @attributes = mock 'Attributes'
      @attributes.stub!(:merge!)
      @module = mock 'A Module'
      
      @generator = MethodGenerator.new(@attributes, @module)
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
  
  describe MethodGenerator, "new" do
    before :each do
      @attributes = mock Attributes
      @attributes.stub!(:merge!)
      @module = Module.new
    end
    
    it "should use the module given" do
      MethodGenerator.new(@attributes, @module).module.should == @module
    end
    
    it "should use the module FixtureReplacement by default" do
      MethodGenerator.new(@attributes).module.should == FixtureReplacement
    end
  end
end
