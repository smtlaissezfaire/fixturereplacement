require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe Attributes do
    before :each do
      @module = Module.new do
        class << self
          include FixtureReplacement::ClassMethods
        end
        
        attributes_for :user do |u|
          u.username = random_string
          u.key = String.random
        end

        attributes_for :scott, :from => :user
        
        attributes_for :foo, :class => User
        
        attributes_for :admin do |a|
          a.admin_status = true
        end
        
      private
      
        def random_string
          String.random
        end
      end

      FixtureReplacementController::MethodGenerator.generate_methods(@module)
      self.class.send :include, @module
    end
    
    it "should have the username as a string (for User) for new_user" do
      new_user.username.class.should == String
    end
    
    it "should have the username as a string (for User) for create_user" do
      create_user.username.class.should == String
    end
    
    it "should have the new_user method as a private method" do
      self.private_methods.should include("new_user")
    end 

    it "should have the create_user method as a private method" do
      self.private_methods.should include("create_user")
    end 

    it "should have the new_foo method as a private method" do
      self.private_methods.should include("new_foo")
    end 

    it "should have the create_foo method as a private method" do
      self.private_methods.should include("create_foo")
    end 

    it "should have the new_scott method as a private method" do
      self.private_methods.should include("new_scott")
    end 

    it "should have the create_scott method as a private method" do
      self.private_methods.should include("create_scott")
    end 
  end
end