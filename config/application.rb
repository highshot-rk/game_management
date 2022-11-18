# frozen_string_literal: true
require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Freankexpo
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: [:get, :post, :options]
      end
    end

    config.autoload_paths << "#{config.root}/lib/local_gems"
    config.autoload_paths << "#{config.root}/app/services/concerns"
    config.eager_load_paths << "#{config.root}/lib/local_gems"
    config.eager_load_paths << "#{config.root}/app/services/concerns"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Cloudflare is disabled for the main website!
    # require "#{Rails.root}/lib/cloud_flare_middleware"
    # config.middleware.insert_before(0, Rack::CloudFlareMiddleware)

    config.assets.precompile += %w(rtl/rtl.scss vendor/application.css embed/embed.scss embed/embed.js)
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.assets.image_optim = {
      nice: 10, svgo: false, pngout: false,
      pngquant: false, jhead: false, jpegoptim: false,
      gifsicle: true
    }

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_job.queue_adapter = :sidekiq
    config.i18n.available_locales = [:en, :de, :es, :fr, :it, :pt, :sv, :id, :nl, :pl, :ru, :zh, :ko, :ja, :uk, :fi, :ms, :hi, :sk, :fa, :tl, :th, :el]

    config.cache_store = :redis_store,
                         (ENV['REDIS_URL'] || 'redis://localhost:6379/0/cache'),
                         { expires_in: 90.minutes }
  end
end
