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
      obj = @class.new
      @class.stub!(:new).and_return obj
      self.send("new_#{@fixture_name}").should == obj
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



  describe MethodGenerator, "generate_new_method for User when user_attributes is defined" do

    #before :each do
    #  @user = User.new
    #
    #  FixtureReplacement.module_eval do
    #    def user_attributes
    #      {
    #        :gender => default_gender
    #      }
    #    end
    #
    #    def gender_attributes
    #      {
    #        :sex => "Male"
    #      }
    #    end
    #
    #    def alien_attributes
    #      {
    #        :gender => default_gender(:sex => "unknown")
    #      }
    #    end
    #  end      
    #
    #  @gender_generator = MethodGenerator.new({:method_base_name => "gender"})
    #  @gender_generator.generate_default_method
    #  @gender_generator.generate_new_method
    #  @gender_generator.generate_create_method
    #
    #  @generator = MethodGenerator.new({:method_base_name => "user"})
    #  @generator.generate_new_method
    #
    #  @generator = MethodGenerator.new({:method_base_name => "alien"})
    #  @generator.generate_new_method
    #end
    #
    #it "should evaluate any of the default_* methods before returning (if no over-writing key is given)" do      
    #  new_gender = new_user.gender
    #  new_gender.sex.should == "Male"
    #end
    #
    #it %(should evaluate any of the default_* methods before returning, with the hash params given to default_* method) do
    #  new_gender = new_alien.gender
    #  new_gender.sex.should == "unknown"
    #end
    #
    #it "should call Gender.save! when the default_gender method is evaluated by default_gender" do
    #  @gender = mock('Gender', :null_object => true)
    #  Gender.stub!(:new).and_return @gender
    #  @user = mock('User')
    #  @user.stub!(:gender=).and_return @gender
    #  User.stub!(:new).and_return @user
    #
    #  @gender.should_receive(:save!)
    #  new_user
    #end
    #
    #it "should not call Gender.save! if the default_gender is overwritten by another value" do
    #  Gender.should_not_receive(:save!)
    #  new_user(:gender => Gender.new)
    #end
    #
    #it "should be able to overwrite a default_* method" do
    #  Gender.should_not_receive(:save!)
    #  new_user(:gender => Gender.create!(:sex => "Female"))
    #end
  end
end


