module FixtureReplacement
  class AttributeBuilder
    class << self
      def validate_instances!
        instances.each do |fixture|
          fixture.validate!
        end

        true
      end

      def instances
        @instances ||= []
      end

      def add_instance(instance)
        instances << instance
      end

      def clear_out_instances!
        @instances = nil
      end

      def find_by_fixture_name(arg)
        instances.detect { |instance| instance.fixture_name == arg }
      end
    end

    def initialize(fixture_name, options={}, &block)
      options.symbolize_keys!

      check_valid_keys(options, [:from, :class])

      @fixture_name    = fixture_name.to_sym
      @attributes_proc = block || lambda {}
      @from            = options[:from].to_sym if options.has_key?(:from)
      @class           = options[:class]

      self.class.add_instance(self)
    end

    attr_reader :fixture_name
    attr_reader :from

    def active_record_class
      @active_record_class ||= find_active_record_class
    end

    def instantiate(hash_to_merge = {}, instance = active_record_class.new)
      returning instance do
        instantiate_parent_fixture(instance)
        call_attribute_body(instance, hash_to_merge)
        add_given_keys(instance, hash_to_merge)
      end
    end

    def validate!
      new_instance = instantiate

      unless new_instance.valid?
        errors = "new_#{fixture_name} is not valid! - Errors: "
        errors << new_instance.errors.map { |key, value| "[#{key}: #{value}]"}.join(", ")
        raise InvalidInstance, errors
      end
    end

  private

    class InvalidKeyError < StandardError; end

    def check_valid_keys(options_given, valid_keys)
      options_given.each do |key, _|
        unless valid_keys.include?(key)
          raise InvalidKeyError, "#{key.inspect} is not a valid option to attributes_for.  Valid keys are: #{valid_keys.inspect}"
        end
      end
    end

    def instantiate_parent_fixture(instance)
      derived_fixture.instantiate({}, instance) if derived_fixture?
    end

    def call_attribute_body(instance, hash_to_merge)
      if @attributes_proc.arity == 2
        @attributes_proc.call(instance, hash_to_merge)
      else
        @attributes_proc.call(instance)
      end
    end

    def add_given_keys(instance, hash_to_merge)
      hash_to_merge.each do |key, value|
        instance.send("#{key}=", value)
      end
    end

    def find_derived_fixture
      self.class.find_by_fixture_name(from)
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

    def find_active_record_class
      if @class
        @class
      else
        begin
          constantize(fixture_name)
        rescue NameError => e
          if derived_fixture?
            derived_fixture.active_record_class
          else
            raise e
          end
        end
      end
    end
  end
end
