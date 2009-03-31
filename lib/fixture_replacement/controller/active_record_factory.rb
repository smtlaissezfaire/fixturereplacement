module FixtureReplacement
  # I am a Factory which creates ActiveRecord Class instances.
  # Give me a collection of attributes, and an additional hash,
  # and I will merge them into a new ActiveRecord Instance (either a new
  # instance with ActiveRecord::Base#new, or a created one ActiveRecord::Base#create!).
  class ActiveRecordFactory
    
    def initialize(klass, attributes)
      @class      = klass
      @attributes = attributes
    end
    
    def to_new_instance
      new_object = @class.new
      assign_values_to_instance new_object
      new_object
    end
    
    def to_created_instance
      created_obj = to_new_instance
      created_obj.save!
      created_obj
    end

  private

    def assign_values_to_instance(instance_object)
      @attributes.each do |key, value|
        instance_object.__send__("#{key}=", evaluate_default_procs(value))
      end
    end

    def evaluate_default_procs(value)
      case value
      when Array
        value.map! { |element| evaluate_default_procs(element) }
      when Proc
        value.call
      else
        value
      end
    end
  end
end