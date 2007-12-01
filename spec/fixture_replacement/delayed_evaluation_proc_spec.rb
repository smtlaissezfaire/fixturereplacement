require File.dirname(__FILE__) + "/../spec_helper"

describe DelayedEvaluationProc do
  it "should be a kind of proc" do
    DelayedEvaluationProc.superclass.should == Proc
  end
end