require File.dirname(__FILE__) + "/spec_helper"

describe "FixtureReplacement.attributes_for" do
  
  it "should yield an OpenStruct" do
    FixtureReplacement.attributes_for :user do |u|      
      u.should be_a_kind_of(OpenStruct)
    end
  end
  
  it "should create a new Attribute with the class, attributes_from, and the attributes" do
    FixtureReplacementController::Attributes.stub!(:new)
    FixtureReplacementController::Attributes.should_receive(:new).with(:scott, {
      :class => User,
      :from => :user,
      :attributes => OpenStruct.new({
        :username => "scott",
        :key => "value"
      })
    })

    FixtureReplacement.attributes_for :scott, :from => :user, :class => User do |u|
      u.username = "scott"
      u.key = "value"
    end
  end
  
  # open_struct = OpenStruct.new
  # 
  # yield open_struct
  # 
  # fixture_attributes_class.new({
  #   :fixture_name => fixture_name,
  #   :class => options[:class],
  #   :attributes_from => options[:from],
  #   :attributes => open_struct
  # })
  # 
  
end