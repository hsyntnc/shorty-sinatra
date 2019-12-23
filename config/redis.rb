require 'redis'

REDIS_HOST = ENV['REDIS_HOST'] || 'localhost'
REDIS_PORT = ENV['REDIS_PORT'] || '6379'

$redis = Redis.new({host: REDIS_HOST, port: REDIS_PORT, keyPrefix: ENV['APP_ENV']})