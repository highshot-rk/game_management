# encoding: UTF-8

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'Events - Indiexpo'
    xml.webMaster 'info@indiexpo.net (indiexpo Staff)'
    xml.description 'International Website about Free Indie Games, Free to Play and Contests.'
    xml.link root_url(locale: nil)
    xml.language 'en-us'

    cache(@cache) do
      @events.each do |event|
        xml.item do
          xml.title event.title
          xml.description event.description
          xml.pubDate event.created_at.to_s(:rfc822)
          xml.link event_url(event.slug, locale: nil)
        end
      end
    end
  end
end
