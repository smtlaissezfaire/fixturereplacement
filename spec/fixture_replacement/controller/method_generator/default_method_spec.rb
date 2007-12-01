require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacementController
  
  describe "MethodGenerator#default_*", :shared => true do
    it "should return a DelayedEvaluationProc" do
      @generator.generate_default_method
      self.send("default_#{@fixture_name}").class.should == DelayedEvaluationProc
    end
    
    it %(should return the special proc, which in turn should return an array 
        of the name of the model ('user') if no params were given) do
      @generator.generate_default_method
      self.send("default_#{@fixture_name}").call.should == [@fixture_name.to_sym, {}]
    end
    
    it %(should return the special proc, which in turn should return an array
        of the name of the model ('user') and the params given) do
      @generator.generate_default_method
      self.send("default_#{@fixture_name}", @params_hash).call.should == [@fixture_name.to_sym, @params_hash]
    end
    
    it "should generate the method default_user in the module" do
      @generator.generate_default_method
      @module.instance_methods.should include("default_#{@fixture_name}")
    end
    
  end

  describe MethodGenerator, "default_user" do
    
    before :each do
      @module = Module.new
      
      @struct = OpenStruct.new({:key => "val"})
      @attributes = Attributes.new(:user, :attributes => @struct)
      @attributes.stub!(:merge!)
      @generator = MethodGenerator.new(@attributes, @module)
      
      @fixture_name = "user"
      extend @module
      
      @params_hash = {:username => "foo"}
    end
    
    it_should_behave_like "MethodGenerator#default_*"    
  end
  
  describe MethodGenerator, "default_admin" do
    
    before :each do
      @module = Module.new
      
      @struct = OpenStruct.new({:key => "val"})
      @attributes = Attributes.new(:admin, :attributes => @struct)
      @attributes.stub!(:merge!)
      @generator = MethodGenerator.new(@attributes, @module)
      
      @fixture_name = "admin"
      @params_hash = {:username => "scott"}
      extend @module
    end
    
    it_should_behave_like "MethodGenerator#default_*"
  end


end