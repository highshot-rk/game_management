# encoding: UTF-8

xml.instruct! :xml, version: '1.0'
xml.rss  "xmlns:yandex": 'http://news.yandex.ru', "xmlns:media": 'http://search.yahoo.com/mrss/', "xmlns:turbo": 'http://turbo.yandex.ru', version: '2.0' do
  xml.channel do
    xml.title 'И́нди-игра́ - indiexpo'
    xml.webMaster 'info@indiexpo.net (indiexpo Staff)'
    xml.copyright "Copyright 2011-#{Time.now.year} indiexpo.net"
    xml.description 'indiexpo это место, где каждый может найти И́нди-игра́ или игры по своему вкусу и даже опубликовать собственные работы.'
    xml.link root_url(locale: nil)
    xml.language 'ru'
    xml.turbo:analytics, type: 'Google', id: 'UA-71765582-1' do end
      xml.image do
        xml.link root_url(locale: nil)
        xml.title 'И́нди-игра́ - indiexpo'
        xml.url asset_url('Images/LogoMask.png')
        xml.description 'indiexpo это место, где каждый может найти И́нди-игра́ или игры по своему вкусу и даже опубликовать собственные работы.'
        xml.width '100'
        xml.height '100'
      end

    cache(@cache) do
      @games.each do |game|
        xml.item turbo: 'true' do
          xml.title game.title
          xml.turbo:source do end
          xml.turbo:topic do end
          xml.author game.author
          xml.category 'Игры'
          xml.pubDate game.created_at.to_s(:rfc822)
          xml.link game_url(game.slug, locale: nil)
          xml.comments game_comments_url(game.slug, locale: nil)
          xml.turbo:content do
            xml.cdata! "#{image_tag(game.image)}<br />#{CGI.escapeHTML(xml_safe(game.description))}"
          end
          xml.metrics do
            xml.yandex schema_identifier: game.id do
              xml.breadcrumb url: root_url(locale: nil), text: 'Главная'
              xml.breadcrumb url: search_url(locale: nil), text: 'Игры'
              xml.breadcrumb url: game_url(game.slug, locale: nil), text: game.title
            end
          end
          xml.yandex:related do end
        end
      end
    end
  end
end