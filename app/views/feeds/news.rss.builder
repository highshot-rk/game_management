# encoding: UTF-8

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title @game.title
    xml.webMaster 'info@indiexpo.net (indiexpo Staff)'
    xml.managingEditor @game.author
    xml.description @game.description
    xml.link game_url(@game.slug, locale: nil)
    xml.language 'en-us'

    @game.news.order(created_at: :desc).each do |news|
      xml.item do
        xml.title @game.title
        xml.author @game.author
        xml.pubDate news.created_at.to_s(:rfc822)
        xml.link game_news_url(@game.slug, locale: nil)
        xml.description do
          xml.cdata! CGI.escapeHTML(news.text).to_s
        end
      end
    end
  end
end
