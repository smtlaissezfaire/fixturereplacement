module FixtureReplacement
  module Controller
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
          if arg.respond_to?(:to_sym)
            instances.detect { |instance| instance.fixture_name == arg.to_sym }
          else
            nil
          end
        end
      end
    
      def initialize(fixture_name, options={})
        @fixture_name    = fixture_name.to_sym
        @attributes_proc = options[:attributes] || lambda { Hash.new }
        @class           = options[:class]
      
        if from = options[:from]
          @from = from.to_sym
        end

        register(self)
      end
    
      attr_reader :fixture_name
      attr_reader :from

      def active_record_class
        if @class
          @class
        elsif @from
          derived_fixture.active_record_class
        else
          constantize(fixture_name)        
        end
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
  
      def find_by_fixture_name(symbol)
        if symbol
          if result = self.class.find_by_fixture_name(symbol)
            result
          else
            raise FixtureReplacement::UnknownFixture, "The fixture definition for `#{symbol}` cannot be found"
          end
        end
      end
    
      def derived_fixture
        @my_fixture ||= find_by_fixture_name(@from)
      end
  
      def constantize(symbol)
        symbol.to_s.camelize.constantize
      end
    
      def register(object)
        self.class.add_instance(self)
      end
    end
  end
end