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
    
  private

    def assign_values_to_instance(instance_object)
      @attributes.each do |key, value|
        instance_object.__send__("#{key}=", value)
      end
    end
  end
end