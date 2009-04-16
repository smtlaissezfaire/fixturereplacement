module FixtureReplacement
  module Version
    unless defined?(FixtureReplacement::VERSION)
      MAJOR = 2
      MINOR = 1
      TINY  = 0

      VERSION = "#{MAJOR}.#{MINOR}.#{TINY}"
    end
  end
end
