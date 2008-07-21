module FixtureReplacementController
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
