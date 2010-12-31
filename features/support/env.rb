require 'rubygems'
require 'bundler/setup'
require 'mongoid'
require 'lib/uatu'
require 'cucumber/formatter/unicode'

Mongoid.configure do |config|
 name = "test"
 host = "localhost"
 config.master = Mongo::Connection.new.db(name)
 config.logger = nil
end

Before do
  AuditLog.destroy_all
  Ninja.destroy_all
end

Uatu.configure do |config|
  config.user_strategy { $current_user }
end
