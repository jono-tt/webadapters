redis_config_filename = File.join(Rails.root, "config", "redis.yml")
redis_config = YAML.load_file(redis_config_filename)[Rails.env]

redis_config["port"] ||= 6379
database = redis_config.delete("db") || 0

$redis = Redis.new(redis_config.symbolize_keys)
$redis.select(database)

Resque.redis = $redis
