module FixtureReplacementController
  dir = File.dirname(__FILE__) + "/controller"
  
  autoload :ActiveRecordFactory,   "#{dir}/active_record_factory"
  autoload :AttributeCollection,   "#{dir}/attribute_collection"
  autoload :ClassFactory,          "#{dir}/class_factory"
  autoload :DelayedEvaluationProc, "#{dir}/delayed_evaluation_proc"
  autoload :MethodGenerator,       "#{dir}/method_generator"
  
  class <<  self
    def defaults_file
      @defaults_file ||= "#{rails_root}/db/example_data.rb"
    end
    
    def defaults_file=(file)
      @defaults_file = file
    end
    
  private
    
    def rails_root
      defined?(RAILS_ROOT) ? RAILS_ROOT : nil
    end
  end
end
