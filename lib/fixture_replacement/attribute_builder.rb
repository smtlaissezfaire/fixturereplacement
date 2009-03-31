module FixtureReplacement
  # I am a series of ActiveRecord model attributes.
  #
  # My attributes come from the following places: 
  #
  #   * from the class which is specified with :from => :fixture_name
  #     when I was constructed
  #   * from the anonymous function which is passed from into my constructor
  #
  class AttributeBuilder
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
        nil
      end
    end
    
    def initialize(fixture_name, options={}, &block)
      @fixture_name    = fixture_name
      @attributes_proc = block || lambda { Hash.new }
      @from            = options[:from]
      @class           = options[:class]

      self.class.add_instance(self)
    end
    
    attr_reader :fixture_name
    attr_reader :from

    def active_record_class
      @class || find_by_fixture_name(@from).active_record_class
    rescue
      constantize(fixture_name)
    end
    
    def procedure_hash
      os = OpenStruct.new
      @attributes_proc.call(os)
      os.marshal_dump
    end
    
    # Procedure for building the hash:
    #
    # 1. Find the hash for the parent builder (specified by :from)
    # 2. Merge #1 (or an empty hash) with the hash given in the body
    # 3. If an extra hash is given to the method, merge that in.
    #
    # to_hash always prefers later key/value pairs in this sequence.
    #
    def to_hash(hash_to_merge=nil)
      if hash_to_merge
        to_hash.merge(hash_to_merge)
      else
        if derived_fixture_is_present?
          derived_fixtures_hash.merge(procedure_hash)
        else
          procedure_hash
        end
      end
    end
    
    def to_new_class_instance(custom_attributes={}, caller=self)
      ActiveRecordFactory.new(active_record_class, to_hash(custom_attributes)).to_new_instance
    end
    
    def to_created_class_instance(custom_attributes={}, caller=self)
      ActiveRecordFactory.new(active_record_class, to_hash(custom_attributes)).to_created_instance
    end
    
  private
  
    def derived_fixtures_hash
      derived_fixture.to_hash
    end
  
    def derived_fixture_is_present?
      derived_fixture ? true : false
    end
    
    def find_by_fixture_name(symbol)
      self.class.find_by_fixture_name(symbol)
    end
    
    def find_derived_fixture
      find_by_fixture_name(from)
    end
    
    def derived_fixture
      @derived_fixture ||= find_derived_fixture
    end
  
    def constantize(symbol)
      symbol.to_s.camelize.constantize
    end
  end
end