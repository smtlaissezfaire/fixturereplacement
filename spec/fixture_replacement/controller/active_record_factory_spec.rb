require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe ActiveRecordFactory::ActiveRecordValueAssigner do
    ValueAssigner = ActiveRecordFactory::ActiveRecordValueAssigner
    
    before :each do
      @object = OpenStruct.new
      @assigner = ValueAssigner.new(@object)
    end
    
    it "should assign a simple value" do
      @assigner.assign(:foo, :bar)
      @object.foo.should equal(:bar)
    end
    
    it "should evaluate a DelayedEvaluationProc in the context of it's caller" do
      a_user = 'mock user'
      self.stub!(:create_user).and_return a_user
      default_user = DelayedEvaluationProc.new { 
        mock 'a fake fixture definition', :fixture_name => "user", :null_object => true
      }
      
      ValueAssigner.assign(@object, :user, default_user, self)
      @object.user.should == a_user
    end
    
    it "should return an array when an array" do
      array = [1,2,3]
      assigner = ValueAssigner.new(@object)
      assigner.assign(:foo, array)
      @object.foo.should == array
    end
    
    it "should keep the attribute as nil if passed FR::UNDEFINED" do
      @assigner.assign(:foo, FR::UNDEFINED)
      @object.foo.should be_nil
    end
    
    it "should keep any old attribute, and not write over it" do
      a_string = String.random(100)
      @object.foo = a_string
      @assigner.assign(:foo, FR::UNDEFINED)
      @object.foo.should == a_string
    end
  end
end
