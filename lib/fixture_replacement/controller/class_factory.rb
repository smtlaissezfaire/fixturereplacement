module FixtureReplacementController
  module ClassFactory
    class << self
      def active_record_factory
        @active_record_factory ||= ActiveRecordFactory
      end

      def fixture_replacement_module
        @fixture_replacement ||= ::FixtureReplacement
      end
    end
  end
end
