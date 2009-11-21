module FixtureReplacement
  module Version
    unless defined?(FixtureReplacement::VERSION)
      MAJOR             = 3
      MINOR             = 0
      TINY              = 1

      version_string = "#{MAJOR}.#{MINOR}.#{TINY}"
      version_string << " RC#{RELEASE_CANDIDATE}" if defined?(RELEASE_CANDIDATE)
      VERSION = version_string
    end
  end
end
