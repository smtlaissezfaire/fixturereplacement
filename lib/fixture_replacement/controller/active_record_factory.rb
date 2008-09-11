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
    
    def to_new_instance
      new_object = @attributes.active_record_class.new
      assign_values_to_instance new_object
      new_object
    end
    
    def to_created_instance
      created_obj = self.to_new_instance
      created_obj.save!
      created_obj
    end
    
    class ActiveRecordValueAssigner
      def self.assign(object, key, value, context)
        new(object).assign(key, value, context)
      end
      
      def initialize(object)
        @object = object
      end
      
      def assign(key, value, context=nil)
        unless value.kind_of?(UndefinedValue)
          @object.__send__("#{key}=", eval(value, context))
        end
      end
      
    private
      
      class Evaluator
        class << self
          alias_method :ruby_eval, :eval
          
          def eval(value, context)
            new(value).eval(context)
          end
        end
        
        def initialize(value)
          @value = value
        end
        
        alias_method :ruby_eval, :eval
        
        def eval(context)
          case @value
          when Array
            @value.map! { |element| self.class.eval(element, context) }
          when DelayedEvaluationProc
            @value.evaluate(context)
          else
            @value
          end
        end
      end
      
      alias_method :ruby_eval, :eval
      
      def eval(value, context)
        Evaluator.eval(value, context)
      end
    end

  protected
  
    def hash_given_to_constructor
      @hash_given_to_constructor || Hash.new
    end
    
  private

    def assign_values_to_instance(instance_object)
      all_attributes.each do |key, value|
        ActiveRecordValueAssigner.assign(instance_object, key, value, @caller)
      end
    end

    def all_attributes
      @all_merged_attributes ||= attributes_hash.merge(self.hash_given_to_constructor)
    end
    
    def attributes_hash
      @attributes.hash
    end
  end
end
