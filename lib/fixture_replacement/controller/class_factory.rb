module FixtureReplacementController
  module ClassFactory
    class << self
      def attribute_collection
        AttributeCollection
      end
    
      def fixture_replacement_module
        ::FixtureReplacement
      end
    end
  end
end