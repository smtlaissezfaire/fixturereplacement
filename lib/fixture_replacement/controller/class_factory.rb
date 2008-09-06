module FixtureReplacementController
  module ClassFactory
    class << self
      def fixture_replacement_module
        @fixture_replacement ||= ::FixtureReplacement
      end
    end
  end
end
