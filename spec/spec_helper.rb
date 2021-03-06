$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'simplecov'
require 'bundler/setup'
require 'pry'
require 'shopify_api'
require 'httparty'
require 'active_record'
require 'webmock/rspec'

SimpleCov.start
#Todo fix this nast connection ENV var thing.
# Allow connections, even though they are nastilly stopped right now. with an ENV var.
WebMock.allow_net_connect!

#  Use NullDB to not use activerecord for access_tokens
require 'nulldb_rspec'
include NullDB::RSpec::NullifiedDatabase

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

include NullDB::RSpec::NullifiedDatabase

# NullDB is lonely and really wants to be configured
# See https://github.com/nulldb/nulldb/blob/master/lib/nulldb/rails.rb#L4
NullDB.configure {|ndb| def ndb.project_root;RAILS_ROOT;end}

# Config some more to suppress after(:all) warnings
# See https://github.com/nulldb/nulldb/blob/master/lib/nulldb_rspec.rb#L101
ActiveRecord::Base.configurations.merge!('test' => { 'adapter' => 'nulldb' })

# Here's where you force NullDB to do your bidding
RSpec.configure do |config|

  config.before(:each) do
    schema_path = File.join(RAILS_ROOT, 'spec/lightspeed_test_schema.rb')
    NullDB.nullify(:schema => schema_path)
  end

  config.after(:each) do
    NullDB.restore
  end

end

require "lightspeed_api"
