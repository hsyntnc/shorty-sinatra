REDIS_HOST = ENV['REDIS_HOST'] || 'localhost'
REDIS_PORT = ENV['REDIS_PORT'] || '6379'

$redis = Redis.Namespace("shorty-#{ENV['APP_ENV']}", redis: Redis.new({host: REDIS_HOST, port: REDIS_PORT}))