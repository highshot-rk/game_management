# encoding: UTF-8
# frozen_string_literal: true
xml.instruct! :xml, version: '1.0'
xml.urlset xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9',
           'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml',
           'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1',
           'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
           'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd' do
  xml << @sitemap_data.pluck(:content).join
end
