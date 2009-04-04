require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "default build method" do
    it "should use create when not specified" do
      obj = use_module do
        self.create_dependent_objects = true
        
        attributes_for :item do |i|
          i.category = default_category
        end
        
        attributes_for :category
      end
      
      item = obj.new_item
      item.category.should_not be_a_new_record
    end
    
    it "should not create the objects if create_dependent_objects = false" do
      obj = use_module do
        self.create_dependent_objects = false
        
        attributes_for :item do |i|
          i.category = default_category
        end

        attributes_for :category
      end

      item = obj.new_item
      item.category.should be_a_new_record
    end
  end
end