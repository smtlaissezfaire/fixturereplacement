require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  # These specs are ugly.  It probably means that I need to refactor AttributeBuilder#to_new_class_instance
  describe AttributeBuilder, "Send Regresssion" do
    before :each do
      @class = Class.new
      @instance = @class.new
      @class.stub!(:new).and_return @instance
      
      @instance.stub!(:foo=)
      
      @attributes = AttributeBuilder.new(:foo, {})
      @attributes.stub!(:active_record_class).and_return @class
      @attributes.stub!(:hash).and_return({:foo => :bar})
    end
    
    it "should be able to send the message (to_new_class_instance), even if the send method has been redefined" do
      @instance.should_not_receive(:send)
      @instance.should_receive(:__send__)
      
      @attributes.to_new_class_instance
    end
  end
end
