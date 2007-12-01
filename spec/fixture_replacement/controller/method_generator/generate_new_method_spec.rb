require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacementController
  
  module MethodGeneratorHelper
    def setup_for_generate_new_method(fixture_name, classname)
      @module = Module.new
      extend @module

      @fixture_name = fixture_name
      @class = classname

      @attributes = Attributes.new(@fixture_name, {
        :attributes => OpenStruct.new({
          :key => "val"
        })
      })
      
      @generator = MethodGenerator.new(@attributes, @module)
      @generator.generate_new_method
    end
  end
  
  describe "MethodGenerator#generate_new_method", :shared => true do
    it "should respond to new_user in the module" do
      @module.instance_methods.should include("new_#{@fixture_name}")
    end

    it "should return a new User object" do
      @class.stub!(:new).and_return @user
      self.send("new_#{@fixture_name}").should == @user
    end

    it "should return a new User object with the keys given in user_attributes" do
      self.send("new_#{@fixture_name}").key.should == "val"
    end

    it "should over-write the User's hash with any hash given to new_user" do
      self.send("new_#{@fixture_name}", :key => "other_value").key.should == "other_value"
    end

    it "should add any hash key-value pairs which weren't previously given in user_attributes" do
      u = self.send("new_#{@fixture_name}", :other_key => "other_value")
      u.key.should == "val"
      u.other_key.should == "other_value"
    end 

    it "should not be saved to the database" do
      self.send("new_#{@fixture_name}").should be_a_new_record
    end   

    it "should be able to be saved to the database" do
      lambda {
        self.send("new_#{@fixture_name}").save!
      }.should_not raise_error      
    end
    
  end

  
  
  describe MethodGenerator, "generate_new_method for User" do
    include MethodGeneratorHelper
    
    before :each do
      setup_for_generate_new_method(:user, User)
    end

    it_should_behave_like "MethodGenerator#generate_new_method"
  end

  describe MethodGenerator, "generate_new_method for Admin" do
    include MethodGeneratorHelper
    
    before :each do
      setup_for_generate_new_method(:admin, Admin)
    end

    it_should_behave_like "MethodGenerator#generate_new_method"
  end

  
end