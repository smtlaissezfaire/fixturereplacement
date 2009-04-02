module SpecHelperFunctions
  def setup_database_connection
    require 'rubygems'
    require 'sqlite3'
    require 'active_record'
    require 'active_support'
    
    ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
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
    end
    
    def use_module(&block)
      mod = Module.new
      mod.extend(FixtureReplacement::ClassMethods)
      mod.instance_eval(&block)

      obj = Object.new
      obj.extend mod
      obj
    end
  end
end
