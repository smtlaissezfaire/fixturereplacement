module FixtureReplacement
  module Version
    def self.revision
      `git-rev-list HEAD`.split("\n").first
    end
    
    MAJOR    = 2
    MINOR    = 8
    TINY     = 0
    REVISION = '099bd07792e5dddaf82aac0b54be7ab7a7553766'
    
    VERSION  = "#{MAJOR}.#{MINOR}.#{TINY} (git #{REVISION})"
  end
end
