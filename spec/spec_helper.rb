ENV['APP_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) { $redis.keys.each {|k| $redis.del k } }
end
