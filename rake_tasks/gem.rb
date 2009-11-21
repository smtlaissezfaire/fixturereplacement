require File.expand_path(File.dirname(__FILE__) + "/../lib/fixture_replacement")

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|
    File.open(File.expand_path(File.dirname(__FILE__) + "/../VERSION"), "w") do |f|
      f << FixtureReplacement::Version::VERSION
    end

    gemspec.name        = "fixture_replacement"
    gemspec.summary     = "The original fixture replacement solution for rails"
    gemspec.email       = "scott@railsnewbie.com"
    gemspec.homepage    = "http://replacefixtures.rubyforge.org"
    gemspec.authors     = ["Scott Taylor"]
    gemspec.description = <<-DESC
FixtureReplacement is a Rails plugin that provides a simple way to
quickly populate your test database with model objects without having to manage multiple,
brittle fixture files. You can easily set up complex object graphs (with models which
reference other models) and add new objects on the fly.
    DESC
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
