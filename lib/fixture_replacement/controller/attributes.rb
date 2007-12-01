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
      
      def find_by_fixture_name(arg)
        instances.each do |instance|
          if instance.fixture_name == arg
            return instance
          end
        end
        return nil
      end
    end
    
    def initialize(h={})
      assign_from_constructor(h)
      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    attr_reader :from

    # I would really like to name this method class, but I'm
    # sure you can see the name conflict
    def of_class
      begin
        @class || find_by_fixture_name(@from).of_class
      rescue
        Object.const_get classify(fixture_name)
      end
    end
    
    def hash
      @merged_hash || @attributes.to_hash
    end
    
    def merge!
      if from = find_by_fixture_name(self.from)
        @merged_hash = from.hash.merge(self.hash)
      end
    end
    
  private
  
    def assign_from_constructor(hash_given)
      hash_given[:fixture_name] ? @fixture_name = hash_given[:fixture_name] : raise
      @attributes = hash_given[:attributes] || Hash.new
      @from, @class = hash_given[:from], hash_given[:class]
    end
  
    attr_reader :hash_given
  
    def find_by_fixture_name(symbol)
      self.class.find_by_fixture_name(symbol)
    end
    
    def classify(symbol)
      symbol.to_s.classify
    end
  end
end