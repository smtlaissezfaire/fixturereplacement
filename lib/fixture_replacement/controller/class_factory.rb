module FixtureReplacementController
  module ClassFactory
    class << self
      def fixture_replacement_module
        ::FixtureReplacement
      end
    end
  end
end