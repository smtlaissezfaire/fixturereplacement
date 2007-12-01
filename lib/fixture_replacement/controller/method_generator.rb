module FixtureReplacementController
  class MethodGenerator
    class << self
      
      def generate_methods
        
      end
      
    end
    
    def initialize(object_attributes, module_class)
      @object_attributes = object_attributes
      @object_attributes.merge!
      @module_class = module_class
    end
    
    def generate_default_method
      
    end
    
    def generate_create_method
      
    end
    
    def generate_new_method
      obj = @object_attributes
      
      @module_class.module_eval do
        define_method("new_#{obj.fixture_name}") do |*args|
          hash = args[0] || Hash.new
          User.new(obj.hash.merge(hash))
        end
      end
    end
  end
end