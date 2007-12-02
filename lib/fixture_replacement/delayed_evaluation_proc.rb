# This is here so that if someone (some how) assigns a proc
# to an accessor on an ActiveRecord object, FixtureReplacement
# won't get tripped up, and try to evaluate the proc.
class DelayedEvaluationProc < Proc; end