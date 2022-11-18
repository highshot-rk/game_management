# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

use Rack::CanonicalHost do |env|
  url = Addressable::URI.parse(Rack::Request.new(env).url)
  if url.host == 'indiexpo.net' || (url.host == 'assets.indiexpo.net' && !url.path.starts_with?('/system/'))
    'www.indiexpo.net'
  end
end
run Rails.application
