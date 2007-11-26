require File.dirname(__FILE__) + "/../spec_helper"

class User < ActiveRecord::Base; end

describe FixtureReplacement do
  before :each do
    @klass = Class.new
    undefine_methods :create_user, :new_user, :default_user, :user_attributes
    
    FixtureReplacement.module_eval do
      def user_attributes
        {
          
        }
      end
    end
  end
  
  def undefine_methods(*methods)
    methods.each do |method_name|
      if FixtureReplacement.instance_methods.include?(method_name.to_s)
        FixtureReplacement.send(:undef_method, method_name)
      end
    end
  end
  
  it "should generate the methods when included" do
    @klass.class_eval do
      include FixtureReplacement
    end
    
    @klass.instance_methods.should include("create_user")
    @klass.instance_methods.should include("new_user")
    @klass.instance_methods.should include("default_user")
  end
  
  it "should not generate the methods before being included" do
    @klass.instance_methods.should_not include("create_user")
    @klass.instance_methods.should_not include("new_user")
    @klass.instance_methods.should_not include("default_user")
  end
end