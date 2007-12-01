require File.dirname(__FILE__) + "/../../../spec_helper"
require File.dirname(__FILE__) + "/../../fixtures/classes"

module FixtureReplacementController
  describe MethodGenerator do
    before :each do
      @user_attributes = mock("UserAttributes")
      @user_attributes.stub!(:merge!)
      @module = mock("FixtureReplacement")
      @generator = MethodGenerator.new(@user_attributes, @module)
    end
    
    it "should have the class method generate_methods" do
      MethodGenerator.should respond_to(:generate_methods)
    end
        
    it "should not raise an error if the model ends with 's'" do
      pending "Is this some weird regression I need to fix, again?"
    end

    it "should be able to respond to generate_default_method" do
      @generator.should respond_to(:generate_default_method)
    end

    it "should respond to generate_create_method" do
      @generator.should respond_to(:generate_create_method)
    end

    it "should respond to generate_new_method" do
      @generator.should respond_to(:generate_new_method)
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

  describe "MethodGenerator#generate_create_method with valid attributes", :shared => true do
    it "should save the user with save!" do
      @user = mock(@class, :null_object => true)
      @user.stub!(:save!).and_return true      
      @class.stub!(:new).and_return @user
      
      @user.should_receive(:save!).with(no_args)
      self.send("create_#{@fixture_name}")
    end
    
    it "should return a kind of the fixture name" do
      self.send("create_#{@fixture_name}").should be_a_kind_of(@class)
    end
    
    it "should return a type (User, Admin,...) which has been saved" do
      self.send("create_#{@fixture_name}").should_not be_a_new_record
    end
    
    it "should user the default hash parameters, if none are given" do
      user = self.send("create_#{@fixture_name}")
      user.key.should == @hash[:key]
      user.username.should == @hash[:username]
    end
    
    it "should be able to overwrite the hash with the parameters given" do
      user = self.send("create_#{@fixture_name}", @hash.merge(:username => "smtlaissezfaire"))
      user.key.should == @hash[:key]
      user.username.should == "smtlaissezfaire"      
    end
  end
  
  describe "MethodGenerator#generate_create_method", :shared => true do
    it "should generate the method new_user" do
      @module.instance_methods.should include("new_#{@fixture_name}")
    end    
    
    it "should generate the method create_fixture_name in the module" do
      @module.instance_methods.should include("create_#{@fixture_name}")
    end
    
    it "should generate the method create_fixture_name which can take an optional hash 
        (it actually takes any number of params, but only uses the first hash given)" do      
      self.method("create_#{@fixture_name}").arity.should == -1
    end
  end

  describe MethodGenerator, "generate_create_method for User when user_attributes is defined (and valid)" do
    
    before :each do 
      @module = Module.new
      extend @module
      
      @fixture_name = :user
      @struct = OpenStruct.new({:username => "scott", :key => "val"})

      @attributes = Attributes.new(@fixture_name, :attributes => @struct)
      @attributes.stub!(:merge!)
      
      @generator = MethodGenerator.new(@attributes, @module)
      @generator.generate_new_method
      @generator.generate_create_method
      
      @hash = {:username => "scott", :key => "val"}
      @class = User
    end
    
    it_should_behave_like "MethodGenerator#generate_create_method"   
    it_should_behave_like "MethodGenerator#generate_create_method with valid attributes" 
  end
  
  describe MethodGenerator, "generate_create_method for Admin" do
    before :each do 
      @module = Module.new
      extend @module
      
      @fixture_name = :admin
      @struct = OpenStruct.new({:username => "scott", :key => "val"})

      @attributes = Attributes.new(@fixture_name, :attributes => @struct)
      @attributes.stub!(:merge!)
      
      @generator = MethodGenerator.new(@attributes, @module)
      @generator.generate_new_method
      @generator.generate_create_method
      
      @hash = {:username => "scott", :key => "val"}
      @class = Admin
    end
    
    it_should_behave_like "MethodGenerator#generate_create_method"
    it_should_behave_like "MethodGenerator#generate_create_method with valid attributes" 
  end

  describe MethodGenerator, "generate_create_method for User when user_attributes is defined, but not valid" do
     
    before :each do 
      @module = Module.new
      extend @module

      @fixture_name = :user
      @struct = OpenStruct.new({:key => nil})

      @attributes = Attributes.new(@fixture_name, :attributes => @struct)
      @attributes.stub!(:merge!)

      @generator = MethodGenerator.new(@attributes, @module)
      @generator.generate_new_method
      @generator.generate_create_method

      @hash = {:key => nil}
      @class = User
    end

    it_should_behave_like "MethodGenerator#generate_create_method"

    it "should not create the record after executing create_user when the user's attributes are invalid
        (it should raise an ActiveRecord::RecordInvalid error)" do
      @generator.generate_create_method
      lambda {
        create_user(:key => nil)
      }.should raise_error(ActiveRecord::RecordInvalid)      
    end

  end
    
end



# 
# describe MethodGenerator, "generate_new_method for User when user_attributes is defined" do
#   include FixtureReplacement
#   
#   before :each do
#     @user = User.new
#     
#     FixtureReplacement.module_eval do
#       def user_attributes
#         {
#           :gender => default_gender
#         }
#       end
#       
#       def gender_attributes
#         {
#           :sex => "Male"
#         }
#       end
#       
#       def alien_attributes
#         {
#           :gender => default_gender(:sex => "unknown")
#         }
#       end
#     end      
#     
#     @gender_generator = MethodGenerator.new({:method_base_name => "gender"})
#     @gender_generator.generate_default_method
#     @gender_generator.generate_new_method
#     @gender_generator.generate_create_method
#     
#     @generator = MethodGenerator.new({:method_base_name => "user"})
#     @generator.generate_new_method
# 
#     @generator = MethodGenerator.new({:method_base_name => "alien"})
#     @generator.generate_new_method
#   end
# 
#   it "should evaluate any of the default_* methods before returning (if no over-writing key is given)" do      
#     new_gender = new_user.gender
#     new_gender.sex.should == "Male"
#   end
#   
#   it %(should evaluate any of the default_* methods before returning, with the hash params given to default_* method) do
#     new_gender = new_alien.gender
#     new_gender.sex.should == "unknown"
#   end
#   
#   it "should call Gender.save! when the default_gender method is evaluated by default_gender" do
#     @gender = mock('Gender', :null_object => true)
#     Gender.stub!(:new).and_return @gender
#     @user = mock('User')
#     @user.stub!(:gender=).and_return @gender
#     User.stub!(:new).and_return @user
#     
#     @gender.should_receive(:save!)
#     new_user
#   end
#   
#   it "should not call Gender.save! if the default_gender is overwritten by another value" do
#     Gender.should_not_receive(:save!)
#     new_user(:gender => Gender.new)
#   end
# 
#   it "should be able to overwrite a default_* method" do
#     Gender.should_not_receive(:save!)
#     new_user(:gender => Gender.create!(:sex => "Female"))
#   end
# end
#   
