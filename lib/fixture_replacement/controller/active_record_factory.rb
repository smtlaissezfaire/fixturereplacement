module FixtureReplacementController
  # I am a Factory which creates ActiveRecord Class instances.
  # Give me a collection of attributes, and an additional hash,
  # and I will merge them into a new ActiveRecord Instance (either a new
  # instance with ActiveRecord::Base#new, or a created one ActiveRecord::Base#create!).
  class ActiveRecordFactory
    
    def initialize(attributes, hash={}, original_caller=self)
      @attributes = attributes
      @hash_given_to_constructor = hash
      @caller = original_caller
    end

    def to_created_instance
      created_obj = self.to_new_instance
      created_obj.save!
      created_obj
    end
    
    def hash_given_to_constructor
      @hash_given_to_constructor || Hash.new
    end

    def to_new_instance
      new_object = @attributes.of_class.new
      assign_values_to_instance new_object
      return new_object
    end
    
  private

    def all_attributes
      @attributes.merge!
      @all_merged_attributes ||= attributes_hash.merge(self.hash_given_to_constructor)
    end
  
    def attributes_hash
      @attributes.hash
    end

    def find_value_from_delayed_evaluation_proc(value)
      default_obj, params = value.call
      value = @caller.__send__("create_#{default_obj.fixture_name}", params)
    end

    def assign_values_to_instance instance_object
      all_attributes.each do |key, value|
        if value.is_a? Array
          value.map! do |element|
            if element.is_a?(DelayedEvaluationProc)
              find_value_from_delayed_evaluation_proc(element)
            else
              element
            end
          end
        elsif value.is_a? DelayedEvaluationProc
          value = find_value_from_delayed_evaluation_proc(value)
        end

        instance_object.__send__("#{key}=", value)             
      end
    end
  end
end