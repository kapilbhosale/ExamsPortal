redis_url = ENV['REDIS_URL'] || "redis://localhost:6379/0"
## DOCKER
# redis_url = ENV['REDIS_URL'] || "redis://redis:6379/0"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end