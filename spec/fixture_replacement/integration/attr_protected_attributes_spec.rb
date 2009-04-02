require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "create_user with attr_protected attributes" do
    before :each do
      @obj = use_module do
        attributes_for :admin do |u|
          u.admin_status = true
          u.name = "Scott"
        end
      end
    end
  
    it "should not complain when an apparent mass assignment has happened with default values" do
      lambda {
        @obj.create_admin
      }.should_not raise_error
    end
    
    it "should not be a new record" do
      @obj.create_admin.should_not be_a_new_record
    end
  
    it "should have admin_status equal to the default value (when it has not been overwritten)" do
      @obj.create_admin.admin_status.should == true
    end
  
    it "should have admin_status equal to the overwritten value" do
      @obj.create_admin(:admin_status => false).admin_status.should be_false
    end
  
    it "should have the other attributes assigned when the attr_value has been overwritten" do
      @obj.create_admin(:admin_status => false).name.should == "Scott"
    end
  
    it "should have the other attributes assigned even when the attr_value has not been overwritten" do
      @obj.create_admin.name.should == "Scott"
    end    
  end

  describe "new_user with attr_protected attributes" do
    before :each do
      @obj = use_module do |s|
        attributes_for :admin do |s|
          s.admin_status = true
          s.name         = "Scott"
        end
      end
    end
    
    it "should return a new Admin with new_admin" do
      @obj.new_admin.should be_a_kind_of(Admin)
    end

    it "should have admin_status equal to the default value (when it has not been overwritten)" do
      @obj.new_admin.admin_status.should == true
    end

    it "should have admin_status equal to the overwritten value" do
      @obj.new_admin(:admin_status => false).admin_status.should be_false
    end

    it "should have the other attributes assigned when the attr_value has been overwritten" do
      @obj.new_admin(:admin_status => false).name.should == "Scott"
    end

    it "should have the other attributes assigned even when the attr_value has not been overwritten" do
      @obj.new_admin.name.should == "Scott"
    end    
  end  
end