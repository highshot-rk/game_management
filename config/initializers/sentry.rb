# frozen_string_literal: true

if defined?(Raven)
  Raven.configure do |config|
    config.dsn = 'https://e760f60350a34dd2b08cf88a517f87c0:f8ad45af4af14558bd86f33e0dde62e9@sentry.elfgamesworks.com/7'
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
