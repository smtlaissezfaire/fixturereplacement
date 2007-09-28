
if ENV["RAILS_ENV"] == "test" || ENV["RAILS_ENV"] == "development"
  begin
    require File.dirname(__FILE__) + "/../../../../db/example_data"
  rescue Exception => e
    raise "Error in FixtureReplacement Plugin: #{e}"
  end
end

require File.dirname(__FILE__) + "/fixture_replacement/string"
require File.dirname(__FILE__) + "/fixture_replacement/fixture_replacement"

FixtureReplacement::Generator.generate_methods
