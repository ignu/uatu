require 'rubygems'
require 'bundler/setup'
require 'funtimes'
require 'mocha'
require 'rspec'
require 'active_model'
require 'mongoid'
require 'uatu'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Mongoid.configure do |config|
 name = "test"
 host = "localhost"
 config.master = Mongo::Connection.new.db(name)
 config.logger = nil
end


RSpec.configure do |config|
  config.mock_with :mocha
end
