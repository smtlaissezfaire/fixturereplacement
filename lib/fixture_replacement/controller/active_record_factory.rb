module FixtureReplacementController
  # I am a Factory which creates ActiveRecord Class instances.
  # Give me a collection of attributes, and an additional hash,
  # and I will merge them into a new ActiveRecord Instance (either a new
  # instance with ActiveRecord::Base#new, or a created one ActiveRecord::Base#create!).
  class ActiveRecordFactory
    
    def initialize(attributes, hash={}, original_caller=self)
      @attributes = attributes
      @hash_given_to_constructor = hash || Hash.new
      @caller = original_caller
    end
    
    def to_new_instance
      new_object = @attributes.active_record_class.new
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
      attributes.each do |key, value|
        value = evaluate_possible_delayed_proc(value)
        instance_object.__send__("#{key}=", value)             
      end
    end

    def evaluate_possible_delayed_proc(value)
      case value
      when Array
        value.map! { |element| evaluate_possible_delayed_proc element }
      when DelayedEvaluationProc
        value.evaluate(@caller)
      else
        value
      end
    end
    
    def attributes
      @attributes.merge!
      @attributes.hash.merge(@hash_given_to_constructor)
    end
  end
end