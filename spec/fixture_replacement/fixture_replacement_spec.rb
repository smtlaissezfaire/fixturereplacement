require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + "/fixtures/classes"

module FixtureReplacementController
  describe MethodGenerator do
    before :each do
      @user_attributes = mock("UserAttributes")
      @user_attributes.stub!(:merge!)
      @module = mock("FixtureReplacement")
      @generator = FixtureReplacementController::MethodGenerator.new(@user_attributes, @module)
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
  
  describe FixtureReplacementController::MethodGenerator, "generate_new_method for User when user_attributes is defined" do
    before :each do
      @user = User.new
      
      @module = Module.new

      @user_attributes = Attributes.new(:user, {
        :attributes => OpenStruct.new({
          :key => "val"
        })
      })
      
      @generator = MethodGenerator.new(@user_attributes, @module)
      @generator.generate_new_method
      extend @module
    end

    it "should respond to new_user in the module" do
      @module.instance_methods.should include("new_user")
    end

    it "should return a new User object" do
      User.stub!(:new).and_return @user
      new_user.should == @user
    end

    it "should return a new User object with the keys given in user_attributes" do
      new_user.key.should == "val"
    end

    it "should over-write the User's hash with any hash given to new_user" do
      new_user(:key => "other_value").key.should == "other_value"
    end

    it "should add any hash key-value pairs which weren't previously given in user_attributes" do
      u = new_user(:other_key => "other_value")
      u.key.should == "val"
      u.other_key.should == "other_value"
    end 

    it "should not be saved to the database" do
      new_user.should be_a_new_record
    end   

    it "should be able to be saved to the database" do
      lambda {
        new_user.save!
      }.should_not raise_error      
    end
  end
end

# describe FixtureReplacementController::MethodGenerator, "default_user, with user_attributes (when they are actually valid)" do
#   include FixtureReplacement
#   
#   before :each do    
#     FixtureReplacement.module_eval do
#       def user_attributes
#         {
#           :key => "val"
#         }
#       end
#     end      
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "user"})
#   end
#   
#   it "should generate the method default_user in the module" do
#     @generator.generate_default_method
#     FixtureReplacement.instance_methods.should include("default_user")
#   end
#   
#   it "should return a DelayedEvaluationProc" do
#     @generator.generate_default_method
#     default_user.class.should == DelayedEvaluationProc
#   end
#   
#   it %(should return the special proc, which in turn should return an array 
#       of the name of the model ('user') if no params were given) do
#     @generator.generate_default_method
#     default_user.call.should == ["user"]
#   end
#   
#   it %(should return the special proc, which in turn should return an array
#       of the name of the model ('user') and the params given) do
#     @generator.generate_default_method
#     default_user({:key => "hash"}).call.should == ["user", {:key => "hash"}]
#   end
# end
# 
# describe FixtureReplacementController::MethodGenerator, "generate_create_method for User when user_attributes is defined (and valid)" do
#   include FixtureReplacement
#   
#   before :each do      
#     FixtureReplacement.module_eval do
#       def user_attributes
#         {
#           :key => "val"
#         }
#       end
#     end      
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "user"})
#     @generator.generate_new_method
#     @generator.generate_create_method
#   end
#   
#   it "should generate the method create_user in the module" do
#     FixtureReplacement.instance_methods.should include("create_user")
#   end
#   
#   it "should generate the method create_user which takes one parameter - a hash" do
#     @generator.generate_create_method
#     create_user({:key => "value"})
#   end
#   
#   it "should return a user" do
#     @generator.generate_create_method
#     create_user.should be_a_kind_of(User)
#   end
#   
#   it "should return a user which has been saved" do
#     @generator.generate_create_method
#     create_user.should_not be_a_new_record
#   end
#   
#   it "should save the user with save!" do
#     @generator.generate_create_method
#     
#     @user = mock('User', :null_object => true)
#     @user.stub!(:save!).and_return true      
#     User.stub!(:new).and_return @user
#     
#     @user.should_receive(:save!).with(no_args)
#     create_user
#   end
#   
#   it "should overwrite the hash parameters given" do
#     @generator.generate_create_method
#     create_user(:key => "value").key.should == "value"
#   end
#   
#   it "should not overwrite the default hash parameters, if none are given" do
#     @generator.generate_create_method
#     create_user.key.should == "val"
#   end
# end
# 
# describe FixtureReplacementController::MethodGenerator, "generate_create_method for User when user_attributes is defined (and valid)" do
#   include FixtureReplacement
#   
#   before :each do
#     FixtureReplacement.module_eval do
#       def user_attributes
#         {
#           :gender => default_gender,
#           :key => "val"
#         }
#       end
#       
#       def gender_attributes
#         {
#           :sex => "Male"
#         }
#       end
#     end      
#     @gender_generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "gender"})
#     @gender_generator.generate_default_method
#     @gender_generator.generate_new_method
#     @gender_generator.generate_create_method
#     
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "user"})
#     @generator.generate_new_method
#     @generator.generate_create_method
#   end
#   
#   it "should save the associated join models which have a default_* method (if it is not overwritten)" do
#     created_gender = create_user.gender
#     created_gender.sex.should == "Male"
#   end
#   
#   it "should save the associated join model with the attributes specified - not with with the default_*'s hash (in the case that the hash is overwritten)" do
#     created_user = create_user(:gender => Gender.create!(:sex => "Female"))
#     created_gender = created_user.gender
#     created_gender.sex.should == "Female"
#   end
#   
#   it "should call save! when the default_gender method is evaluated by default_gender" do
#     @gender = mock('Gender', :null_object => true)
#     Gender.stub!(:new).and_return @gender
#     
#     @user = mock('User', :null_object => true)
#     User.stub!(:new).and_return @user
#     @user.stub!(:gender=).and_return @gender
# 
#     @gender.should_receive(:save!).with(no_args)
#     create_user
#   end
#   
#   it "should not call Gender.save! if the default_gender is overwritten by another value" do
#     Gender.should_not_receive(:save!)
#     create_user(:gender => Gender.new)
#   end
# end
# 
# describe FixtureReplacementController::MethodGenerator, "generate_create_method for User when user_attributes is defined, but not valid" do
#   include FixtureReplacement
#   
#   before :each do      
#     FixtureReplacement.module_eval do
#       def user_attributes
#         {
#           :key => nil
#         }
#       end
#     end      
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "user"})
#     @generator.generate_new_method
#     @generator.generate_create_method
#   end
#   
#   it "should generate the method create_user in the module" do
#     FixtureReplacement.instance_methods.should include("create_user")
#   end
#   
#   it "should generate the method create_user" do
#     @generator.generate_create_method
#     FixtureReplacement.instance_methods.should include("create_user")
#   end
#   
#   it "should generate the method create_user which takes a hash" do
#     @generator.generate_create_method
#     create_user(:key => "value")
#   end
#   
#   it "should not create the record after executing create_user when the user's attributes are invalid
#       (it should raise an ActiveRecord::RecordInvalid error)" do
#     @generator.generate_create_method
#     lambda {
#       create_user(:key => nil)
#     }.should raise_error(ActiveRecord::RecordInvalid)      
#   end
#   
# end
# 

# 
# describe FixtureReplacementController::MethodGenerator, "generate_new_method for User when user_attributes is defined" do
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
#     @gender_generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "gender"})
#     @gender_generator.generate_default_method
#     @gender_generator.generate_new_method
#     @gender_generator.generate_create_method
#     
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "user"})
#     @generator.generate_new_method
# 
#     @generator = FixtureReplacementController::MethodGenerator.new({:method_base_name => "alien"})
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
# describe "FixtureReplacementController::MethodGenerator.generate_methods" do
#   before :each do
#     @module = mock(FixtureReplacement)
#     @module.stub!(:instance_methods).and_return ["user_attributes", "item_attributes", "some_other_method"]
#     
#     @generator = mock(FixtureReplacementController::MethodGenerator)
#     FixtureReplacementController::MethodGenerator.stub!(:new).and_return @generator
#     @generator.stub!(:generate_default_method).and_return nil
#     @generator.stub!(:generate_new_method).and_return nil
#     @generator.stub!(:generate_create_method).and_return nil
#   end    
#   
#   it "should respond to the method" do
#     FixtureReplacementController::MethodGenerator.should respond_to(:generate_methods)
#   end
#   
#   it "should use the FixtureReplacement module if none provided" do
#     FixtureReplacementController::MethodGenerator.generate_methods
#   end
#   
#   it "should take an optional module name" do
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should create a new generator object for the user when user_attributes is defined" do
#     FixtureReplacementController::MethodGenerator.should_receive(:new).with({:method_base_name => "user"}, @module).and_return @generator
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should create a new generator object for the item when item_attributes is defined" do
#     FixtureReplacementController::MethodGenerator.should_receive(:new).with({:method_base_name => "item"}, @module).and_return @generator
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should not create a new generator object for the model if no model_name_attributes is defined" do
#     FixtureReplacementController::MethodGenerator.should_not_receive(:new).with({:method_base_name => "model_name_attributes"})
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should not create a new generator object for a method which does not match *_attributes" do
#     FixtureReplacementController::MethodGenerator.should_not_receive(:new).with({:method_base_name => "some_other_method"}, @module)
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should call generate_default_method for each of the *_attributes models" do
#     @generator.should_receive(:generate_default_method).twice
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
#   
#   it "should call generate_new_method for each of the *_attributes models" do
#     @generator.should_receive(:generate_new_method).twice
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)      
#   end
#   
#   it "should call generate_create_method for each of the *_attributes models" do
#     @generator.should_receive(:generate_create_method).twice
#     FixtureReplacementController::MethodGenerator.generate_methods(@module)
#   end
# end  
# 