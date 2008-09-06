module FixtureReplacement
  module Version
    def self.revision
      `git-rev-list HEAD`.split("\n").first
    end
    
    MAJOR    = 2
    MINOR    = 8
    TINY     = 0
    REVISION = self.revision
    
    VERSION  = "#{MAJOR}.#{MINOR}.#{TINY} (git #{REVISION})"
  end
end
module FixtureReplacement
  module Version
    def self.revision
      `git-rev-list HEAD`.split("\n").first
    end
    
    MAJOR    = 2
    MINOR    = 8
    TINY     = 0
    REVISION = 0f96ac3d96d44b7293c1cf5c37e071901c520a49
    
    VERSION  = "#{MAJOR}.#{MINOR}.#{TINY} (git #{REVISION})"
  end
end
