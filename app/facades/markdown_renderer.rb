class MarkdownRenderer < Redcarpet::Render::HTML
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def paragraph(text)
    text.gsub! (/(?<=^|[\s.,]|\w[;'])(@([^\s.,]+))/) do |match|
      user = User.where('LOWER(username) = ?', $2.downcase).first
      if user != nil
        link_to "#{$1}", user_path($2, locale: nil), data: { game_card: card_game_path($2, locale: nil) }, class: 'textc60', target: '_blank'
      else
        link_to "#{$1}", search_path(search: { author: $2 }), class: 'textc60', target: '_blank'
      end
    end
    text.gsub! (/(?<=^|[\s.,]|\w[;'])(#([^\s.,]+))/) do |match|
      link_to "#{$1}", search_path(search: { q: $2 }), class: 'textc60', data: { analytics_click: 'tag hashtag' }, target: '_blank'
    end
    text.gsub! (/\|\|([^|]*)\|\|/) do |match|
      %(<font class="spoiler">#{match}</font>)
    end
    "#{text}<br>"
  end

  def block_code(_code, _language); end

  def block_html(_raw_html); end

  def footnotes(_content); end

  def footnote_def(_content, _number); end

  def header(_text, _header_level); end

  def hrule(); end

  def table(_header, _body); end

  def table_row(_content); end

  def table_cell(_content, _alignment); end

  def codespan(_code); end

  def image(_link, _title, _alt_text); end

  def link(_link, _title, _content); end

  def autolink(link, link_type)
    case link
      when /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:embed\/|v\/|&v=\/|watch\?v=|\/watch\?feature=youtu\.be&v)|youtu\.be\/|gaming\.youtube\.com\/watch\?v=|m\.youtube\.com\/)([\w\-_]+)(?:([\S]+))?/ then youtube_link(link)
      when /((?:https?)?:\/\/\S*\.(?i:png|jpe?g|gif))/ then image_link(link)
      else normal_link(link)
    end
  end

  def youtube_link(link)
    video_id = link.match(/(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:embed\/|v\/|&v=\/|watch\?v=|\/watch\?feature=youtu\.be&v)|youtu\.be\/|gaming\.youtube\.com\/watch\?v=|m\.youtube\.com\/)([\w\-_]+)(?:([\S]+))?/)
    "<br><a class=\"WidFlo\" target=\"_blank\" href=\"https://youtu.be/#{video_id[1]}\"><img alt=\"YouTube Gameplay\" class=\"embed_preview\" src=\"https://i.ytimg.com/vi/#{video_id[1]}/mqdefault.jpg\"></a>"
  end

  def image_link(link)
    "<br><img alt=\"Comment Image\" class=\"embed_preview\" data-zoom-image=\"#{link}\" src=\"#{link}\"><br>"
  end

  def normal_link(link)
    "<a target=\"_blank\" rel=\"nofollow\" href=\"#{link}\">#{link}</a>"
  end

  def raw_html(_raw_html); end

  def footnote_ref(_number); end

  def list(contents, _list_type)
    contents
  end

  def list_item(text, _list_type)
    "- #{text}"
  end
end
