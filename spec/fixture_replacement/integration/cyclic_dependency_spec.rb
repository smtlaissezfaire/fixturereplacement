require File.dirname(__FILE__) + "/../../spec_helper"

describe "cyclic dependencies" do
  before do
    @mod = use_module do
      attributes_for :event do |e, hash|
        e.schedule = new_schedule(:event => e) unless hash[:schedule]
      end

      attributes_for :schedule do |s, hash|
        s.event = new_event(:schedule => s) unless hash[:event]
      end
    end
  end

  it "should allow them" do
    @mod.new_event.should be_a_kind_of(Event)
  end

  it "should associate an event with a schedule" do
    @mod.new_event.schedule.should be_a_kind_of(Schedule)
  end

  it "should associate a schedule with an event" do
    @mod.new_schedule.event.should be_a_kind_of(Event)
  end

  it "should back associate" do
    schedule = @mod.new_schedule
    schedule.event.schedule.should == schedule
  end
end
