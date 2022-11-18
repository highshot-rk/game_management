# encoding: UTF-8
xml.instruct! :xml, version: '1.0'
xml.urlset xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9',
           'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml',
           'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1',
           'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
           'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd' do
  # Home page
  xml << render('url', params: { url: ->(p) { root_url(p) }, priority: 1, freq: 'always', image: { url: asset_url('Images/LogoMask.png'), title: 'IndiExpo.net', caption: 'Free to Play and Free Indie Games' } })
  # Sign Up
  xml << render('url', params: { url: ->(p) { new_user_registration_url(p) }, priority: 1, freq: 'yearly', image: { url: asset_url('Images/pages/register.png'), title: 'Sign up', caption: 'Sign up on indiexpo website' } })
  # Login
  xml << render('url', params: { url: ->(p) { new_user_session_url(p) }, priority: 1, freq: 'yearly', image: { url: asset_url('Images/pages/login.png'), title: 'Login', caption: 'Log in on indiexpo website' } })
  # Developers
  xml << render('url', params: { url: ->(p) { developers_url(p) }, priority: 1, freq: 'yearly', image: { url: asset_url('Images/pages/developers.png'), title: 'Developers', caption: 'Developers of Indie Games' } })
  # FAQ
  xml << render('url', params: { url: ->(p) { faq_url(p) }, priority: 1, freq: 'yearly', image: { url: asset_url('Images/pages/faq.png'), title: 'FAQ', caption: 'The FAQ of indiexpo website' } })
  # Search
  xml << render('url', params: { url: ->(p) { search_url(p) }, priority: 0.9, freq: 'weekly', image: { url: asset_url('Images/pages/search.png'), title: 'Search VideoGame', caption: 'Search Free Indie Games' } })
  # Game Chart
  xml << render('url', params: { url: ->(p) { chart_games_url(p) }, priority: 0.9, freq: 'weekly', image: { url: asset_url('Images/pages/chart.png'), title: 'Game Chart', caption: 'Chart Free Indie Games' } })
  # Game Chart Downloaded
  xml << render('url', params: { url: ->(p) { chart_games_url(p) }, url_params: { filter: :downloaded }, priority: 0.9, freq: 'weekly', image: { url: asset_url('Images/pages/downloaded.png'), title: 'Most Downloaded Games', caption: 'Most Downloaded Free Indie Games' } })
  # Game News
  xml << render('url', params: { url: ->(p) { news_games_url(p) }, priority: 0.9, freq: 'weekly', image: { url: asset_url('Images/pages/news.png'), title: 'Game News', caption: 'The News about the Free Indie Games' } })
  # About
  xml << render('url', params: { url: ->(p) { about_url(p) }, priority: 0.8, freq: 'yearly', image: { url: asset_url('Images/LogoMask.png'), title: 'About indiexpo', caption: 'About indiexpo website' } })
  # Console
  xml << render('url', params: { url: ->(p) { indiepad_games_url(p) }, priority: 0.8, freq: 'monthly', image: { url: asset_url('Images/pages/console.png'), title: 'The Indieconsole', caption: 'The Game Console of indiexpo to play using the indiepads' } })
  # Events
  xml << render('url', params: { url: ->(p) { events_url(p) }, priority: 0.8, freq: 'weekly', image: { url: asset_url('Images/pages/events.png'), title: 'Events on Free Indie Games', caption: 'All Events About Free Indie Games' } })
  # Past Events
  xml << render('url', params: { url: ->(p) { events_url(p) }, url_params: { passed: true }, priority: 0.7, freq: 'weekly', image: { url: asset_url('Images/pages/events.png'), title: 'Past Events About Free Indie Games', caption: 'All Past Events About Free Indie Games' } })
  # SiteMap
  xml << render('url', params: { url: ->(p) { sitemap_url(p) }, priority: 0.4, freq: 'yearly', image: { url: asset_url('Images/pages/sitemap.png'), title: 'The SiteMap of indiexpo website', caption: 'The several areas to explore on indiexpo' } })
  # Terms and Conditions
  xml << render('url', params: { url: ->(p) { license_url(p) }, priority: 0.4, freq: 'yearly' })
  # Feed RSS
  xml << render('url', params: { url: ->(p) { feed_url(p) }, priority: 0.4, freq: 'yearly', image: { url: asset_url('Images/pages/feed.png'), title: 'The Feed RSS of indiexpo website', caption: 'The several feed rss to follow about the games categories on indiexpo' } })
  # Recover
  xml << render('url', params: { url: ->(p) { new_user_password_url(p) }, priority: 0.3, freq: 'yearly', image: { url: asset_url('Images/pages/recover.png'), title: 'Recover your password', caption: 'Recover your password to log in on indiexpo website' } })
end
