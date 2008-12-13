require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  module Controller
    describe AttributeCollection do
      before :each do
        @module = Module.new do
          extend FixtureReplacement::ClassMethods
        
          attributes_for :user do |u|
            u.key = String.random
            u.username = "smtlaissezfaire"
          end
        end
        FixtureReplacement::Controller.fr = @module
        FixtureReplacement::Controller::MethodGenerator.generate_methods
        self.class.send :include, @module
      end
    
      it "should have the username as smtlaissezfaire" do
        new_user.username.should == "smtlaissezfaire"
      end
    
      it "should not have the username when passing FR::UNDEFINED" do
        new_user(:username => FR::UNDEFINED).username.should be_nil
      end
    end
  end
end