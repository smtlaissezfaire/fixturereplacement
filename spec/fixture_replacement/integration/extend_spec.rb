require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "extending an object" do
    it "should not create the create_* method in every instance of the class" do
      mod = Module.new do
        extend FixtureReplacement::ClassMethods
        
        attributes_for :user do |x|
          x.first_name = "Scott"
        end
      end
      
      o1 = Object.new
      o1.extend mod

      Object.new.should_not respond_to(:create_user)
    end
  end
  
  describe "including an object" do
    it "should include methods into instances of the class" do
      mod = Module.new do
        extend FixtureReplacement::ClassMethods

        attributes_for :user do |x|
          x.first_name = "Scott"
        end
      end

      klass = Class.new { include mod }
      obj = klass.new
      
      obj.should respond_to(:create_user)
    end
  end
end