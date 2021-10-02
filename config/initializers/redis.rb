redis_url = ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
# if Rails.env.production?
#   redis_url = "redis://:DkkX5KYHVNmb3RmM6frM@103.224.245.55:6379/0"
# else
#   redis_url = "redis://localhost:6379/0"
# end

REDIS_CACHE = Redis.new({ url: redis_url})

begin
  REDIS_CACHE.get("key")
rescue Redis::CannotConnectError => ex
  puts "*****************************************"
  puts ex
  puts "*****************************************"
  REDIS_CACHE = nil
end