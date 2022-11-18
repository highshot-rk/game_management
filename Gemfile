# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.7.2'

gem 'bootsnap', require: false

# Upgrade
gem 'activemodel-serializers-xml'
gem 'rails-controller-testing'
gem 'record_tag_helper', '~> 1.0'

gem 'rails-i18n'
# Use postgresql as the database for Active Record
gem 'pg'
gem 'pg_search'

# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'bourbon'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# gem 'critical-path-css-rails', github: 'ProGM/critical-path-css-rails'

# Rails config files
gem 'config'

# Use jquery as the JavaScript library
# Required using rails-assets
# gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks', github: 'rails/turbolinks'
gem 'pjax_rails', github: 'ProGM/pjax_rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Intelligen eagerloading for models
gem 'goldiloader'

# Authentication
gem 'devise'
gem 'devise-i18n'

# Pagination
gem 'kaminari'
gem 'kaminari-i18n'

# Background processing
gem 'sidekiq'
# gem 'sidekiq-statistic'
# gem 'sinatra', require: false

# Counter caches
gem 'after_commit_action'
gem 'counter_culture'

# Time Validations
gem 'validates_timeliness', '~> 4.0'

gem 'friendly_id', '~> 5.2'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'

# Detects the users preferred language
gem 'http_accept_language'

# Use passenger as the app server
gem 'passenger'

# Notifications
gem 'public_activity'

# File uploads
gem 'paperclip', '~> 5.0'
gem 'delayed_paperclip', '~> 3.0.1' # , github: 'jrgifford/delayed_paperclip'
gem 'jquery-fileupload-rails'

gem 'image_optim'
gem 'image_optim_pack'

gem 'paperclip-optimizer'

# Markdown
gem 'redcarpet'

# Client Side Validations
gem 'client_side_validations' #, github: 'DavyJonesLocker/client_side_validations', branch: 'rails5'

gem 'pundit'

gem 'draper', '3.0.0.pre1'

gem 'active_record_union'

gem 'closure_tree'

gem 'js-routes'

gem 'mini_magick'

gem 'rubyzip'

gem 'redis-rails', '~> 5.0.2'
gem 'redis-store', '>= 1.4.0'

gem 'rack-canonical-host'
gem 'rack-cors', require: 'rack/cors'

# the /admin panel
gem 'activeadmin', '~> 1.0.0.pre2'
gem 'inherited_resources'

# Improve caching
gem 'multi_fetch_fragments'

gem 'lograge'

# Fast .blank? implementation
gem 'fast_blank'

# A fast way to get local or remote image sizes
gem 'fastimage'

gem 'puma'

group :production do
  gem 'sentry-raven'
end

group :test do
  # gem 'test_after_commit'
  gem 'rspec-sidekiq'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug'

  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'factory_girl'
  gem 'fuubar'

  gem 'rb-readline'

  # gem 'coverage'
  gem 'bundler-audit'

  # Consistency, performance and other analysis
  gem 'consistency_fail'
  gem 'guard'
  # gem 'guard-livereload', require: false
  gem 'guard-brakeman', require: false
  gem 'guard-rspec', require: false
  gem 'guard-consistency_fail', require: false
  gem 'guard-bundler-audit', require: false
  gem 'bullet'

  # Security scanner for Ruby on Rails applications
  gem 'brakeman', require: false
  gem 'rails_best_practices', require: false
end

gem 'bower-rails', '~> 0.10.0'

group :development do
  # gem 'mysql2', require: false

  gem 'rubocop', require: false

  gem 'i18n-tasks', '~> 0.9.5'
  gem 'i18n-html_extractor', github: 'ProGM/i18n-html_extractor'
  gem 'letter_opener'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  gem 'annotate'
  gem 'rack-mini-profiler'
  unless Gem.win_platform?
    gem 'flamegraph'
    gem 'stackprof'
  end
  gem 'derailed'
  gem 'solargraph', require: false

  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
