require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do  
  create_table :users do |t|
    t.column  :key,       :string
    t.column  :other_key, :string
    t.column  :gender_id, :integer
  end
  
  create_table :genders do |t|
    t.column  :sex, :string
  end
  
  create_table :aliens do |t|
    t.column :gender_id, :string
  end
  
  create_table :admins do |t|
    t.column :admin_status, :boolean
    t.column :name, :string
  end  
end

# We need this just so that the tests don't fail
# when we are running the tests outside of a real rails project.
# Otherwise, the tests would fail with a file not found error,
# since db/example_data.rb is no where to be found
def swap_out_require!
  Kernel.module_eval do
    alias_method :__old_require, :require
    
    def require(string)
      unless string == "/db/example_data.rb"
        __old_require(string)
      end
    end
  end
end

swap_out_require!

require File.dirname(__FILE__) + "/../lib/fixture_replacement"
