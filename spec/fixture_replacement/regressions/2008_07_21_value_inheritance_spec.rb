# Bug Report:
#
# [#17083] :from => :fixture_name only works one level down
# Submitted By:
# Scott Taylor (smtlaissezfaire) 	Date Submitted:
# 2008-01-14 16:06
#
# Detailed description
#
# It should work from two levels down, and so on:
#
#
# class Item < ActiveRecord::Base; end
# class Writing < Item; end
#
#
# attributes_for :item do |i|    
#   i.cache_latest_activity_time = 10.days.ago
# end
#
# attributes_for :writing, :from => :item, :class => Writing
#
#
# attributes_for :long_writing, :from => :writing, :class => Writing do |i|
# end
#
# in script/console:
#
# Loading development environment (Rails 2.0.2)
# >> include FixtureReplacement
# => Object
# >> create_long_writing
# ActiveRecord::StatementInvalid: Mysql::Error: #23000Column 'cache_latest_activity_time' cannot be null: INSERT INTO
# `items` (`cache_latest_activity_time`) VALUES(NULL)
#         from /Users/smt/src/web/urbis/branches/scott/paginate-reviews/vendor/rails/activerecord/lib/active_record/connec
# tion_adapters/abstract_adapter.rb:150:in `log'
#         from /Users/smt/src/web/urbis/branches/scott/paginate-reviews/vendor/rails/activerecord/lib/active_record/connec
# tion_adapters/mysql_adapter.rb:281:in `execute'
#         from /Users/smt/src/web/urbis/branches/scott/paginate-reviews/vendor/rails/activerecord/lib/active_record/connec
# tion_adapters/abstract/database_statements.rb:156:in `insert_sql'
#         from /Users/smt/src/web/urbis/branches/scott/paginate-reviews/vendor/rails/activerecord/lib/active_record/connec
# tion_adapters/mysql_adapter.rb:291:in `insert_sql'
#         from

require File.dirname(__FILE__) + "/../../spec_helper"

module FixtureReplacementController
  describe AttributeCollection do
    before :each do
      @now = Time.now
      Time.stub!(:now).and_return @now
      
      @module = Module.new do
        extend FixtureReplacement::ClassMethods

        attributes_for :item do |i|    
          i.cache_latest_activity_time = Time.now
        end

        attributes_for :writing, :from => :item, :class => Writing

        attributes_for :long_writing, :from => :writing, :class => Writing
      end
      
      FixtureReplacementController.fr = @module
      FixtureReplacementController::MethodGenerator.generate_methods
      self.class.send :include, @module
    end
    
    it "should be able to create a new item with the proper time" do
      create_item.cache_latest_activity_time.should == @now
    end
    
    it "should be able to create a new writing with the proper time" do
      create_writing.cache_latest_activity_time.should == @now
    end
    
    it "should be able to create a new long_writing with the proper time" do
      pending 'regression: FIXME'
      create_long_writing.cache_latest_activity_time.should == @now
    end
    
    it "should be able to instantiate a new long_writing with the proper time" do
      pending 'regresssion: FIXME'
      new_long_writing.cache_latest_activity_time.should == @now
    end
  end
end
