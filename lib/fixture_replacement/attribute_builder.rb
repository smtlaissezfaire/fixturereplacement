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
      if @class
        @class
      elsif derived_fixture?
        derived_fixture.active_record_class
      else
        constantize(fixture_name)
      end
    end
    
    def procedure_hash
      os = OpenStruct.new
      @attributes_proc.call(os)
      os.marshal_dump
    end
    
    def to_hash(hash_to_merge=nil)
      evaluate_attributes(to_hash_with_procs(hash_to_merge))
    end

    # Procedure for building the hash:
    #
    # 1. Find the hash for the parent builder (specified by :from)
    # 2. Merge #1 (or an empty hash) with the hash given in the body
    # 3. If an extra hash is given to the method, merge that in.
    #
    # to_hash always prefers later key/value pairs in this sequence.
    #
    def to_hash_with_procs(hash_to_merge = nil)
      if hash_to_merge
        to_hash_with_procs.merge(hash_to_merge)
      else
        if derived_fixture?
          derived_fixtures_hash.merge(procedure_hash)
        else
          procedure_hash
        end
      end
    end
    
  private
  
    def derived_fixtures_hash
      derived_fixture.to_hash
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
    
    def derived_fixture?
      derived_fixture ? true : false
    end
  
    def constantize(symbol)
      symbol.to_s.camelize.constantize
    end
    
    def evaluate_attribute(value)
      case value
      when Array
        value.map! { |element| evaluate_attribute(element) }
      when Proc
        value.call
      else
        value
      end
    end
    
    def evaluate_attributes(hash)
      new_hash = {}
      
      hash.each do |key, value|
        new_hash[key] = evaluate_attribute(value)
      end
      
      new_hash
    end
  end
end