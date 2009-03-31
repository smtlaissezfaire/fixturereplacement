require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "default_method" do
    def use_module(&block)
      mod = Module.new
      mod.extend(FixtureReplacement::ClassMethods)
      mod.instance_eval(&block)
      
      MethodGenerator.generate_methods(mod)
      extend mod
    end
    
    it "should create a proc" do
      use_module do
        attributes_for :user
      end
      
      default_user.should be_a_kind_of(Proc)
    end
    
    it "should instantiate a new instance of the class when calling the proc generated" do
      use_module do
        attributes_for :user do |u|
          u.key = :foo
        end
      end
      
      default_user.call.should be_a_kind_of(User)
    end
    
    it "should create the object" do
      use_module do
        attributes_for :user do |u|
          u.key = :foo
        end
      end
      
      obj = default_user.call
      obj.should_not be_a_new_record
    end
  end
end