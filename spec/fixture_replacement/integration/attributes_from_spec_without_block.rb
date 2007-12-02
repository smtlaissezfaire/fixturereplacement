require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe Attributes do
    before :each do
      @module = Module.new do
        extend FixtureReplacement::ClassMethods
        
        attributes_for :user do |u|
          u.username = String.random
          u.key = String.random
        end

        attributes_for :scott, :from => :user
        
        attributes_for :foo, :class => User
        
        attributes_for :admin do |a|
          a.admin_status = true
        end
      end
      extend @module
      
      FixtureReplacementController::MethodGenerator.generate_methods(@module)
    end
    
    it "should have all of the methods" do
      self.should respond_to(:default_user)
      self.should respond_to(:default_scott)
      self.should respond_to(:default_foo)
      self.should respond_to(:default_admin)
      self.should respond_to(:new_user)
      self.should respond_to(:new_scott)
      self.should respond_to(:new_foo)
      self.should respond_to(:create_user)
      self.should respond_to(:create_scott)
      self.should respond_to(:create_foo)
    end
  end
end