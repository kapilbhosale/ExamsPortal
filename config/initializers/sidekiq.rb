if Rails.env.production?
  redis_url = "redis://:DkkX5KYHVNmb3RmM6frM@103.224.245.55:6379/0"
else
  redis_url = "redis://localhost:6379/0"
end
## DOCKER
# redis_url = ENV['REDIS_URL'] || "redis://redis:6379/0"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end