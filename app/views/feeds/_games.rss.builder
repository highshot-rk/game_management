# encoding: UTF-8

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title title
    xml.webMaster 'info@indiexpo.net (indiexpo Staff)'
    xml.copyright "Copyright 2011-#{Time.now.year} indiexpo.net"
    xml.description 'International Website about Free Indie Games, Free to Play and Contests.'
    xml.link root_url(locale: nil)
    xml.language 'en-us'
      xml.image do
        xml.link root_url(locale: nil)
        xml.title title
        xml.url asset_url('Images/LogoMask.png')
        xml.description 'Play Games on indiexpo'
        xml.width '100'
        xml.height '100'
      end

    cache(cache) do
      games.each do |game|
        xml.item do
          xml.title game.title
          xml.author game.author
          xml.category 'Game'
          xml.pubDate game.created_at.to_s(:rfc822)
          xml.link game_url(game.slug, locale: nil)
          xml.comments game_comments_url(game.slug, locale: nil)
          xml.description do
            xml.cdata! "#{image_tag(game.image)}<br />#{CGI.escapeHTML(xml_safe(game.description))}"
          end
        end
      end
    end
  end
end
