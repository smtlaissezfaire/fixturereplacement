require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "including methods" do
    def use_module(&block)
      mod = Module.new
      mod.extend(FixtureReplacement::ClassMethods)
      mod.instance_eval(&block)
      
      MethodGenerator.generate_methods(mod)
      extend mod
    end
    
    it "should have the create_user method as public" do
      use_module do
        attributes_for :user
      end
      
      self.public_methods.should include("create_user")
    end
    
    it "should respond_to? create_user" do
      use_module do
        attributes_for :user
      end

      self.respond_to?(:create_user).should be_true
    end
  end
end