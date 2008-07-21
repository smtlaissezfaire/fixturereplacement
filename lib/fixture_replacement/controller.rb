module FixtureReplacementController
  dir = File.dirname(__FILE__) + "/controller"
  
  autoload :ActiveRecordFactory,   "#{dir}/active_record_factory"
  autoload :AttributeCollection,   "#{dir}/attribute_collection"
  autoload :ClassFactory,          "#{dir}/class_factory"
  autoload :DelayedEvaluationProc, "#{dir}/delayed_evaluation_proc"
  autoload :MethodGenerator,       "#{dir}/method_generator"
end
