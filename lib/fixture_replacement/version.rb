module FixtureReplacement
  module Version
    def self.revision
      `git-rev-list HEAD`.split("\n").first
    end
    
    MAJOR    = 2
    MINOR    = 8
    TINY     = 0
    REVISION = '8026e77cba55f64d1f372fcb6fb5824bb1bd828f'
    
    VERSION  = "#{MAJOR}.#{MINOR}.#{TINY} (git #{REVISION})"
  end
end
