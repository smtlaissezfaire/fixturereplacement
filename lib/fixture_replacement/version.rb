module FixtureReplacement
  module Version
    def self.revision
      `git-rev-list HEAD`.split("\n").first
    end
    
    MAJOR    = 2
    MINOR    = 8
    TINY     = 0
    REVISION = 'b6d298620cfbd6de6a398f526f619d4a2a6cdab7'
    
    VERSION  = "#{MAJOR}.#{MINOR}.#{TINY} (git #{REVISION})"
  end
end
