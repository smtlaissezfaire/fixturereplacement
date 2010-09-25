
project_root    = File.join(File.dirname(__FILE__), "..")
rails_root      = File.join(project_root, "..", "..", "..")
rails_boot_file = File.join(rails_root, "config", "boot.rb")

running_rails = File.exists?(rails_boot_file) ? true : false

if !running_rails
  raise "Must be inside of a rails project.  See garlic.rb"
end

FileUtils.cp_r File.join(File.dirname(__FILE__), "database.yml"),
               File.join(rails_root, "config", "database.yml")

ENV["RAILS_ENV"] ||= "test"
require File.join(rails_root, "config", "environment")

$:.unshift project_root
require 'lib/fixture_replacement'
require 'lib/fr'

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.column  :key,       :string
    t.column  :other_key, :string
    t.column  :gender_id, :integer
    t.column  :username,  :string
  end

  create_table :players, :force => true do |t|
    t.column :username, :string
    t.column :key, :string
  end

  create_table :genders, :force => true do |t|
    t.column  :sex, :string
  end

  create_table :aliens, :force => true do |t|
    t.column :gender_id, :string
  end

  create_table :admins, :force => true do |t|
    t.column :admin_status, :boolean
    t.column :name, :string
    t.column :username, :string
    t.column :key, :string
    t.column :other_key, :string
  end

  create_table :items, :force => true do |t|
    t.column :category, :integer
    t.column :type, :string
    t.column :name, :string
  end

  create_table :categories, :force => true do |t|
    t.column :name, :string
  end

  create_table :subscribers, :force => true do |t|
    t.column :first_name, :string
  end

  create_table :subscriptions, :force => true do |t|
    t.column :name, :string
  end

  create_table :subscribers_subscriptions, :force => true, :id => false do |t|
    t.column :subscriber_id, :integer
    t.column :subscription_id, :integer
  end

  create_table :events, :force => true do |t|
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end

  create_table :schedules, :force => true do |t|
    t.integer :event_id
  end

  create_table :posts, :force => true do |t|
    t.timestamps
  end

  create_table :comments, :force => true do |t|
    t.integer :post_id
    t.timestamps
  end

  create_table :no_validations, :force => true do |t|
    t.timestamps
  end

  create_table :validate_names, :force => true do |t|
    t.string :name
  end

  create_table :validate_name_twos, :force => true do |t|
    t.string :name
  end

  create_table :address_with_valid_cities, :force => true do |t|
    t.string :city
  end

  create_table :address_with_valid_city_and_states, :force => true do |t|
    t.string :city
    t.string :state
  end
end

def mock_fr_module(&block)
  mod = Module.new
  mod.extend(FixtureReplacement::ClassMethods)
  mod.instance_eval(&block)
  mod
end

def use_module(&block)
  mod = mock_fr_module(&block)

  obj = Object.new
  obj.extend mod
  obj
end