# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV['REDIS_URL'] || 'redis://localhost:6379/4',
    network_timeout: 5
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDIS_URL'] || 'redis://localhost:6379/4',
    network_timeout: 5
  }
end
