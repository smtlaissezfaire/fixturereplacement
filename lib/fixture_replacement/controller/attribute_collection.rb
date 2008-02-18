module FixtureReplacementController
  # I am a series of ActiveRecord model attributes.
  #
  # My attributes come from the following places: 
  #
  #   * from the class which is specified with :from => :fixture_name
  #     when I was constructed
  #   * from the anonymous function which is passed from into my constructor
  #
  class AttributeCollection
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
      
      # Finds the fixture by the given name
      # If there are duplicate fixtures with the same name,
      # it will find the first one which was specified.  It will
      # return nil if no fixture with the name given was found
      def find_by_fixture_name(arg)
        instances.each { |instance| return instance if instance.fixture_name == arg }
        return nil
      end
    end
    
    def initialize(fixture_name, h={})
      @fixture_name = fixture_name
      assign_from_constructor(h)
      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    attr_reader :from

    def active_record_class
      @class || find_by_fixture_name(@from).active_record_class
    rescue
      constantize(fixture_name)
    end
    
    def hash
      return @merged_hash if @merged_hash
      os = OpenStruct.new
      @attributes_proc.call(os)
      os.to_hash
    end
    
    # This merges the :from attributes hash and the attributes from
    # the anonymous function, overriding any attributes derived from
    # the :from hash, with the ones given in the closure.
    def merge!
      if derived_fixture_is_present?
        unmerge_hash
        @merged_hash = derived_fixtures_hash.merge(hash)
      end
    end
    
    def to_new_class_instance(hash={}, caller=self)
      ActiveRecordFactory.new(self, hash, caller).to_new_instance
    end
    
    def to_created_class_instance(hash={}, caller=self)
      ActiveRecordFactory.new(self, hash, caller).to_created_instance
    end
    
  private
  
    def unmerge_hash
      @merged_hash = nil
    end
  
    def derived_fixtures_hash
      derived_fixture.hash
    end
  
    def derived_fixture_is_present?
      !derived_fixture.nil?
    end
    
    def find_by_fixture_name(symbol)
      self.class.find_by_fixture_name(symbol)
    end
    
    def find_derived_fixture
      find_by_fixture_name(self.from)
    end
    
    def derived_fixture
      @my_fixture ||= find_derived_fixture
    end
  
    def assign_from_constructor(hash_given)
      @attributes_proc = hash_given[:attributes] || lambda { Hash.new }
      @from = hash_given[:from]
      @class = hash_given[:class]
    end
  
    attr_reader :hash_given
  
    def constantize(symbol)
      symbol.to_s.camelize.constantize
    end
  end
end