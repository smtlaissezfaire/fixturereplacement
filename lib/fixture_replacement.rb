begin
  require 'rubygems'
  require 'active_support' 
  require 'ostruct'
  
  dir = File.dirname(__FILE__) + "/fixture_replacement"
  require "#{dir}/extensions"
  
  autoload :FixtureReplacementController,  "#{dir}/controller"
  autoload :FixtureReplacement,            "#{dir}/fixture_replacement"
  autoload :FR,                            "#{dir}/fixture_replacement"
  autoload :FixtureReplacement,            "#{RAILS_ROOT}/db/example_data" if defined?(RAILS_ROOT)
rescue LoadError => e
  raise LoadError, "Error in FixtureReplacement Plugin: #{e}"
end
