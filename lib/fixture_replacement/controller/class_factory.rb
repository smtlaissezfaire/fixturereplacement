module FixtureReplacementController
  module ClassFactory
    class << self
      def attribute_collection
        AttributeCollection
      end
    
      def fixture_replacement_module
        ::FixtureReplacement
      end
    
      def delayed_evaluation_proc
        FixtureReplacementController::DelayedEvaluationProc
      end
    
      def fake_active_record_instance
        OpenStruct
      end
    end
  end
end