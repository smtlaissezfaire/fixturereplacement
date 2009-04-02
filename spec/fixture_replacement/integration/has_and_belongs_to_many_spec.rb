require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacement
  describe "HasAndBelongsToMany Associations" do
    before :each do
      @obj = use_module do
        attributes_for :subscriber do |s|
          s.first_name = "Scott"
          s.subscriptions = [default_subscription]
        end

        attributes_for :subscription do |s|
          s.name = "The New York Times"
        end

        attributes_for :subscriber_with_two_subscriptions, :from => :subscriber, :class => Subscriber do |s|
          s.subscriptions = [default_harpers_subscription, default_ny_times_subscription]
        end

        attributes_for :harpers_subscription, :class => Subscription do |s|
          s.name = "Harper's Magazine"
        end

        attributes_for :ny_times_subscription, :from => :subscription, :class => Subscription
      end
    end

    it "should have the fixture create_subscriber" do
      @obj.should respond_to(:create_subscriber)
    end
    
    it "should have the fixture create_subscription" do
      @obj.should respond_to(:create_subscription)
    end
    
    it "should be able to create a new subscriber" do
      lambda {
        @obj.create_subscriber
      }.should_not raise_error
    end
    
    it "should have the subscriber with the default subscription" do
      subscriber = @obj.create_subscriber
      subscriber.should have(1).subscription
      subscriber.subscriptions.first.name.should == "The New York Times"
    end
    
    it "should be able to create a subscriber with two subscriptions (inline)" do
      subscription_one = @obj.create_harpers_subscription
      subscription_two = @obj.create_ny_times_subscription
      
      subscriptions = [subscription_one, subscription_two]
      
      subscriber = @obj.create_subscriber(:subscriptions => subscriptions)
      
      subscriber.subscriptions.should == subscriptions
    end
    
    it "should be able to create a subscriber with two subscriptions, from the fixtures" do
      subscriber = @obj.create_subscriber_with_two_subscriptions
      subscriber.should have(2).subscriptions
    end
  end
end