if Rails.env.development?
  Rack::MiniProfiler.config.auto_inject = false
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfiler.config.start_hidden = true
  Rack::MiniProfiler.config.toggle_shortcut = true
end
