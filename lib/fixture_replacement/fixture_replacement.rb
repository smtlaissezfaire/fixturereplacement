# TODO:
#
# 5. Refactor - Never Done? - This is particularly hard now.  
#    
#    Scope is a big concern.  How would I refactor mod.module_eval { define_method { }} bits?  Instance_eval would work,
#    but then we need to deal with block params, and the value of self.  
#
#    Another problem: How would I refactor out what comes inside of the define_method, short of adding private methods
#    to the module in question? 
# 7. Lot's of error checking needs to go on
# 11. Remove Duplication/DRY!

require 'rubygems'
require 'active_support' 

class FixtureReplacementError < StandardError; end

module FixtureReplacement

  class DelayedEvaluationProc < Proc; end

  class Generator
  
    class << self
      def generate_methods(mod=FixtureReplacement)
        mod.instance_methods.each do |method|          
          if method =~ /(.*)_attributes/
            generator = Generator.new($1, mod)          
            generator.generate_default_method
            generator.generate_new_method
            generator.generate_create_method
          end
        end
      end
      
      # This uses a DelayedEvaluationProc, not a typical proc, for type checking.
      # It maybe absurd to try to store a proc in a database, but even if someone tries,
      # they won't get an error from FixtureReplacement, since the error would be incredibly unclear
      def merge_unevaluated_method(obj, method_for_instantiation, hash={})
        hash.each do |key, value|
          if value.kind_of?(::FixtureReplacement::DelayedEvaluationProc)
            model_name, args = value.call
            hash[key] = obj.send("#{method_for_instantiation}_#{model_name}", args)
          end
        end
      end
    end
    
    attr_reader :model_name
    attr_reader :model_class
    attr_reader :fixture_module
    
    def initialize(method_name, fixture_mod=FixtureReplacement)
      @model_name = method_name
      @model_class = method_name.classify
      @fixture_module = fixture_mod
      
      add_to_class_singleton(@model_class)
    end
    
    def generate_default_method
      model_as_string = model_name
      default_method = "default_#{model_name}".to_sym

      fixture_module.module_eval do
        define_method(default_method) do |*args|
          ::FixtureReplacement::DelayedEvaluationProc.new do
            [model_as_string, *args]
          end
        end
      end
    end
    
    def generate_create_method
      new_method = "new_#{model_name}".to_sym
      create_method = "create_#{model_name}".to_sym
      attributes_method = "#{model_name}_attributes".to_sym
      class_name = @model_name.to_class
      
      fixture_module.module_eval do
        define_method(create_method) do |*args|          
          hash_given = args[0] || Hash.new
          merged_hash = self.send(attributes_method).merge(hash_given)
          evaluated_hash = Generator.merge_unevaluated_method(self, :create, merged_hash)        
          obj = class_name.create!(evaluated_hash)
          obj          
        end
      end
    end
    
    def generate_new_method
      new_method = "new_#{model_name}".to_sym
      attributes_method = "#{model_name}_attributes".to_sym
      class_name = @model_name.to_class

      fixture_module.module_eval do
        define_method new_method do |*args|
          hash_given = args[0] || Hash.new
          merged_hash = self.send(attributes_method).merge(hash_given)
          evaluated_hash = Generator.merge_unevaluated_method(self, :create, merged_hash)
          class_name.new(evaluated_hash)
        end
      end
    end
    
  private

    def add_to_class_singleton(obj)
      string = self.class.const_get(@model_class)

      model_name.instance_eval <<-HERE
        def to_class
          #{string}
        end
      HERE
    end
    
  end
end

