module FixtureReplacementController
  class Attributes
    class << self
      def instances
        @instances ||= []
      end
      
      def add_instance(instance)
        @instances ||= []
        @instances << instance
      end
      
      def clear_out_instances!
        @instances = nil
      end
    end
    
    def initialize(h={})
      h[:fixture_name] ? @fixture_name = h[:fixture_name] : raise
      @attributes = h[:attributes] || Hash.new
      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    
    def hash
      @attributes.to_hash
    end
  end
end