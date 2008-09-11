require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe AttributeCollection do
    before :each do
      redefine_method_missing_on_nil!
      
      @module = Module.new do
        extend FixtureReplacement::ClassMethods

        attributes_for :user do |i|    
          i.key = "Scott"
        end
      end
      
      FixtureReplacementController.fr = @module
      FixtureReplacementController::MethodGenerator.generate_methods
      self.class.send :include, @module
    end
    
    after :each do
      restore_method_missing_on_nil!
    end
    
    def redefine_method_missing_on_nil!
      NilClass.class_eval do
        public :method_missing
        alias_method :old_method_missing, :method_missing
        
        def method_missing(msg, *args, &blk)
          nil
        end
      end
    end
    
    def restore_method_missing_on_nil!
      NilClass.class_eval do
        im = instance_methods
        
        method_missing_present = im.include?("method_missing")
        old_method_missing_present = im.include?("old_method_missing")
        
        if old_method_missing_present && method_missing_present
          alias_method :method_missing, :old_method_missing
          undef :old_method_missing
        elsif old_method_missing_present
          raise "Couldn't find new method missing on NilClass"
        elsif method_missing_present
          raise "Couldn't find old method missing on NilClass"
        else
          raise "Could find neither method_missing nor old method missing on Nilclass"
        end
      end
    end
    
    it "should have nil.foobar return nil" do
      nil.foobar.should == nil
    end
    
    it "should have NilClass#method_missing as public" do
      NilClass.public_instance_methods.should include("method_missing")
    end
    
    it "should be able to create a new record without error" do
      lambda { 
        create_user
      }.should_not raise_error
    end
    
    it "should not be nil" do
      create_user.should_not be_nil
    end
  end
end

