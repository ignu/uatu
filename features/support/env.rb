require 'rubygems'
require 'bundler/setup'
require 'lib/uatu'
require 'mongoid'
require 'cucumber/formatter/unicode'

Mongoid.configure do |config|
 name = "test"
 host = "localhost"
 config.master = Mongo::Connection.new.db(name)
 config.logger = nil
end

Uatu.configure do |config|
  config.user_strategy { $current_user }
end
