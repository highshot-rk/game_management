I18n.available_locales.each do |language|
  query_language = language == I18n.default_locale ? nil : language
  xml.url do
    xml.loc params[:url].call(params[:url_params].to_h.merge!(locale: query_language))

    I18n.available_locales.each do |inner_language|
      query_language = inner_language == I18n.default_locale ? nil : inner_language
      next if inner_language == language

      xml.tag! 'xhtml:link', rel: 'alternate', hreflang: inner_language,
                             href: params[:url].call(params[:url_params].to_h.merge!(locale: query_language))
    end

    if params[:image]
      xml.tag! 'image:image' do
        xml.tag! 'image:loc', params[:image][:url]
        xml.tag! 'image:title', params[:image][:title]
        xml.tag! 'image:caption', params[:image][:caption]
      end
    end

    xml.changefreq params[:freq]
    xml.priority params[:priority]
  end
end
