
require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'active_support'

require 'test/unit'

RAILS_ROOT = "."

require File.dirname(__FILE__) + "/../spec/spec_helpers"
include SpecHelperFunctions

setup_database_connection

require File.dirname(__FILE__) + "/../lib/fixture_replacement"
require File.dirname(__FILE__) + "/../spec/fixture_replacement/fixtures/classes"


class Test::Unit::TestCase
end
