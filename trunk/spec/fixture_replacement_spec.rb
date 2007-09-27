
require File.dirname(__FILE__) + "/../lib/fixture_replacement"

# It would be better if these things were actual mocks/stubs
# of ActiveRecord Classes.  
class ARBase
  class << self
    def create!(h={})
      obj = new(h)
      obj.save!
      obj
    end
  end

  def initialize(hash={})
    @hash = hash
  end
  
  attr_reader :hash
  
  def gender # this would be a has_many call in rails
    17
  end
  
  def save!
    @saved = true
  end
  
  def saved?
    @saved || false
  end  
  
end

class User < ARBase; end
class Gender < ARBase; end


module FixtureReplacement
  describe Generator, "creation" do
    before :each do
      @generator = Generator.new("user")
    end
    
    it "should take a lowecase-model name as it's paramaters" do
      @generator.model_name.should == "user"
    end
    
    it "should be able to take tell the name of model in  string" do
      @generator.model_name.to_s.should == "user"
    end
    
    it "should be able to tell the name of the model's class" do      
      @generator.model_class.should == "User"
    end
    
    it "should be able to convert the name of the model's class into a constant" do
      @generator.model_name.to_class.should == User
    end
    
    it "should raise an error if the constant cannot be found" do
      lambda {
        Generator.new("unknown_model")
      }.should raise_error
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
  
  describe Generator, "default_user, with user_attributes (when they are actually valid)" do
    before :each do
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :key => :val
          }
        end
      end      
      @generator = Generator.new("user")
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new
    end
    
    it "should generate the method default_user in the module" do
      @generator.generate_default_method
      FixtureReplacement.instance_methods.should include("default_user")
    end
    
    it "should return a ::FixtureReplacement::DelayedEvaluationProc" do
      @generator.generate_default_method
      @instance.default_user.class.should == ::FixtureReplacement::DelayedEvaluationProc
    end
    
    it "should return the special proc, which in turn should return the name of the model ('user')" do
      @generator.generate_default_method
      @instance.default_user.call.should == "user"
    end
  end

  describe Generator, "generate_create_method for User when user_attributes is defined (and valid)" do
    before :each do
      User.class_eval do
        def save!
          @saved = true
        end
      end
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :key => :val
          }
        end
      end      
      @generator = Generator.new("user")
      @generator.generate_new_method
      @generator.generate_create_method
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new      
    end
    
    it "should generate the method create_user in the module" do
      FixtureReplacement.instance_methods.should include("create_user")
    end
    
    it "should generate the method create_user which takes one parameter - a hash" do
      @generator.generate_create_method
      @instance.create_user({:key => :value})
    end
    
    it "should return a user" do
      @generator.generate_create_method
      @instance.create_user.should be_a_kind_of(User)
    end
    
    it "should return a user which has been saved (with create!)" do
      @generator.generate_create_method
      @instance.create_user.should be_saved
    end
    
    it "should overwrite the hash parameters given" do
      @generator.generate_create_method
      @instance.create_user(:key => :value).hash.should == {:key => :value}      
    end
    
    it "should not overwrite the default hash parameters, if none are given" do
      @generator.generate_create_method
      @instance.create_user.hash.should == {:key => :val}
    end
  end
  
  describe Generator, "generate_create_method for User when user_attributes is defined (and valid)" do
    before :each do
      User.class_eval do
        def save!
          @saved = true
        end
      end
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :gender => default_gender
          }
        end
        
        def gender_attributes
          {
            :sex => "Male"
          }
        end
      end      
      @gender_generator = Generator.new("gender")
      @gender_generator.generate_default_method
      @gender_generator.generate_new_method
      @gender_generator.generate_create_method
      
      @generator = Generator.new("user")
      @generator.generate_new_method
      @generator.generate_create_method
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new      
    end
    
    it "should save the associated join models which have a default_* method (if it is not overwritten)" do
      created_user = @instance.create_user
      created_gender = created_user.hash[:gender]
      created_gender.hash.should == {:sex => "Male"}
    end
    
    it "should not save the associated join model, but not as the default_* method (in the case that it is overwritten)" do
      created_user = @instance.create_user(:gender => Gender.create!(:sex => "Female"))
      created_gender = created_user.hash[:gender]
      created_gender.hash.should == {:sex => "Female"}
    end
    
    it "should call Gender.create! when the default_gender method is evaluated by default_gender" do
      gender = Gender.new
      Gender.should_receive(:create!).and_return gender
      @instance.create_user
    end
    
    it "should not call Gender.create! if the default_gender is overwritten by another value (say, a string)" do
      Gender.should_not_receive(:create!)
      @instance.create_user(:gender => "a string")
    end
  end
  
  describe Generator, "generate_create_method for User when user_attributes is defined, but not valid" do
    before :each do
      User.class_eval do
        def save!
          @saved = true
        end
      end      
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :key => :val
          }
        end
      end      
      @generator = Generator.new("user")
      @generator.generate_new_method
      @generator.generate_create_method
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new      
    end
    
    it "should generate the method create_user in the module" do
      FixtureReplacement.instance_methods.should include("create_user")
    end
    
    it "should generate the method create_user which takes one parameter - a hash" do
      @generator.generate_create_method
      @instance.create_user({:key => :value})
    end
    
    it "should raise an error with a user which has been saved (with create!)" do
      User.class_eval do
        def save!
          raise
        end
      end
      
      @generator.generate_create_method
      lambda {
        @instance.create_user  
      }.should raise_error
    end    
    
  end

  describe Generator, "generate_new_method for User when user_attributes is defined" do
    before :each do
      @user = User.new
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :key => :val
          }
        end
        
        def gender_attributes
          {
            :sex => "Male"
          }
        end
      end      
      @generator = Generator.new("user")
      @generator.generate_new_method
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new      
      
    end
    
    it "should respond to new_user in the module" do
      FixtureReplacement.instance_methods.should include("new_user")
    end
    
    it "should return a new User object" do
      User.stub!(:new).and_return @user
      @instance.new_user.should == @user
    end
    
    it "should return a new User object with the keys given in user_attributes" do
      @instance.new_user.hash.should == {:key => :val}
    end
    
    it "should over-write the User's hash with any hash given to new_user" do
      @instance.new_user(:key => :other_value).hash.should == {:key => :other_value}
    end
    
    it "should add any hash key-value pairs which weren't previously given in user_attributes" do
      @instance.new_user(:other_key => :other_value).hash.should == {:key => :val, :other_key => :other_value}
    end    
  end
  
  describe Generator, "generate_new_method for User when user_attributes is defined" do
    before :each do
      @user = User.new
      
      FixtureReplacement.module_eval do
        def user_attributes
          {
            :gender => default_gender
          }
        end
        
        def gender_attributes
          {
            :sex => "Male"
          }
        end
      end      
      
      @gender_generator = Generator.new("gender")
      @gender_generator.generate_default_method
      @gender_generator.generate_new_method
      
      @generator = Generator.new("user")
      @generator.generate_new_method
      
      @class = Class.new do
        include FixtureReplacement
      end
      @instance = @class.new      
    end
  
    it "should evaluate any of the default_* methods before returning (if no over-writing key is given)" do      
      new_user = @instance.new_user
      new_gender = new_user.hash[:gender]
      new_gender.hash.should == {:sex => "Male"}
    end
    
    it "should call Gender.save! when the default_gender method is evaluated by default_gender" do
      Gender.should_receive(:create!)
      @instance.new_user
    end
    
    it "should not call Gender.new if the default_gender is overwritten by another value (say, a string)" do
      Gender.should_not_receive(:create!)
      @instance.new_user(:gender => "a string")
    end
  
    it "should be able to overwrite a default_* method" do
      new_user = @instance.new_user(:gender => Gender.create!(:sex => "Female"))
      created_gender = new_user.hash[:gender]
      created_gender.hash.should == {:sex => "Female"}
    end
  end
  
  describe "Generator.generate_methods" do
    before :each do
      @module = mock(FixtureReplacement)
      @module.stub!(:instance_methods).and_return ["user_attributes", "item_attributes", "some_other_method"]
      
      @generator = mock(Generator)
      Generator.stub!(:new).and_return @generator
      @generator.stub!(:generate_default_method).and_return nil
      @generator.stub!(:generate_new_method).and_return nil
      @generator.stub!(:generate_create_method).and_return nil
    end    
    
    it "should respond to the method" do
      Generator.should respond_to(:generate_methods)
    end
    
    it "should use the FixtureReplacement module if none provided" do
      Generator.generate_methods
    end
    
    it "should take an optional module name" do
      Generator.generate_methods(@module)
    end
    
    it "should create a new generator object for the user when user_attributes is defined" do
      Generator.should_receive(:new).with("user", @module).and_return @generator
      Generator.generate_methods(@module)
    end
    
    it "should create a new generator object for the item when item_attributes is defined" do
      Generator.should_receive(:new).with("item", @module).and_return @generator
      Generator.generate_methods(@module)
    end
    
    it "should not create a new generator object for the model if no model_name_attributes is defined" do
      Generator.should_not_receive(:new).with("model_name_attributes")
      Generator.generate_methods(@module)
    end
    
    it "should not create a new generator object for a method which does not match *_attributes" do
      Generator.should_not_receive(:new).with(nil)
      Generator.generate_methods(@module)
    end
    
    it "should call generate_default_method for each of the *_attributes models" do
      @generator.should_receive(:generate_default_method).twice
      Generator.generate_methods(@module)
    end
    
    it "should call generate_new_method for each of the *_attributes models" do
      @generator.should_receive(:generate_new_method).twice
      Generator.generate_methods(@module)      
    end
    
    it "should call generate_create_method for each of the *_attributes models" do
      @generator.should_receive(:generate_create_method).twice
      Generator.generate_methods(@module)
    end
    
  end  
end
