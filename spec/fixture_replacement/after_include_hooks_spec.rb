require File.dirname(__FILE__) + "/../spec_helper"

describe FixtureReplacement, "after_include" do
  before :each do
    @module = Module.new do
      class << self
        include FixtureReplacement::ClassMethods
      end
    end
  end
  
  it "should exist" do
    FixtureReplacement.should respond_to(:after_include)
  end
  
  it "should not execute the block right away" do
    executed = false
    @module.after_include do
      executed = true
    end
    
    executed.should be_false
  end
  
  it "should execute the block after it is included" do
    executed = false
    @module.after_include do
      executed = true
    end
    
    mod = @module
    self.class.class_eval do
       include mod
    end
    
    executed.should be_true
  end
end
