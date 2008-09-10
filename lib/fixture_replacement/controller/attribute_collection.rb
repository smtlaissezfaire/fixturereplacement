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
        instances.detect { |instance| instance.fixture_name == arg }
      end
    end
    
    def initialize(fixture_name, options={})
      @fixture_name = fixture_name
      @attributes_proc = options[:attributes] || lambda { Hash.new }
      @attributes = options[:attributes] || lambda { Hash.new }
      @from = options[:from]
      @class = options[:class]

      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    attr_reader :from

    def active_record_class
      @class || find_by_fixture_name(@from).active_record_class
    rescue
      constantize(fixture_name)
    end
    
    def to_new_class_instance(hash={}, caller=self)
      construct_new_active_record_factory(hash, caller).to_new_instance
    end
    
    def to_created_class_instance(hash={}, caller=self)
      construct_new_active_record_factory(hash, caller).to_created_instance
    end
    
    def to_hash
      hash = derived_fixture ? derived_fixture.to_hash : { }
      os = OpenStruct.new(hash)
      @attributes_proc.call(os)
      os.to_hash
    end
    
    alias_method :hash, :to_hash
  
  private
    
    def construct_new_active_record_factory(hash, caller)
      ActiveRecordFactory.new(self, hash, caller)
    end
  
    attr_reader :hash_given
  
    def unmerge_hash!
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
  
    def constantize(symbol)
      symbol.to_s.camelize.constantize
    end
  end
end
