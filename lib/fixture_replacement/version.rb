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
