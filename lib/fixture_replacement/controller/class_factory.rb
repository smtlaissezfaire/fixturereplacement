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
    end
  end
end
