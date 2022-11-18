# encoding: UTF-8
xml.instruct! :xml, version: '1.0'
xml.sitemapindex xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.sitemap do
    xml.loc pages_sitemap_url(format: :xml, locale: nil)
  end

  (SitemapFragment.where(fragmentable_type: 'User').count / 500 + 1).to_i.times do |page|
    xml.sitemap do
      xml.loc users_sitemap_url(format: :xml, page: page + 1, locale: nil)
    end
  end

  (SitemapFragment.where(fragmentable_type: 'Event').count / 500 + 1).to_i.times do |page|
    xml.sitemap do
      xml.loc events_sitemap_url(format: :xml, page: page + 1, locale: nil)
    end
  end

  (SitemapFragment.where(fragmentable_type: 'Game').count / 500 + 1).to_i.times do |page|
    xml.sitemap do
      xml.loc games_sitemap_url(format: :xml, page: page + 1, locale: nil)
    end
  end
end