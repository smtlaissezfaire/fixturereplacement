require File.dirname(__FILE__) + "/../../../spec_helper"

module FixtureReplacement
  describe MethodGenerator, "Evaluation loading" do
    before :each do
      @module = Module.new
      extend @module

      item_attributes = lambda do |o|
        o.category = default_category
      end
      
      writing_attributes = lambda do |w|
        w.name = "foo"
      end

      @item_attributes = AttributeBuilder.new(:item, :attributes => item_attributes)
      @writing_attributes = AttributeBuilder.new(:writing, :from => :item, :attributes => writing_attributes, :class => Writing)
      AttributeBuilder.new(:category)
    end

    it "should not raise an error if the a default_* method is referenced before it is defined" do
      lambda {
        MethodGenerator.generate_methods(@module)
      }.should_not raise_error
    end 
  end
end