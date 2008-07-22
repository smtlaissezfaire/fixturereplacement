module FixtureReplacementController
  module ClassFactory
    class << self
      def active_record_factory
        @active_record_factory ||= ActiveRecordFactory
      end

      def method_generator
        @method_generator ||= MethodGenerator
      end
    
      def attribute_collection
        @attribute_collection ||= AttributeCollection
      end
    
      def fixture_replacement_module
        @fixture_replacement ||= ::FixtureReplacement
      end
    
      def delayed_evaluation_proc
        @delayed_evaluation_proc ||= FixtureReplacementController::DelayedEvaluationProc
      end
    
      def fake_active_record_instance
        @fake_active_record_instance ||= OpenStruct
      end
    end
  end
end
