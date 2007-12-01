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
