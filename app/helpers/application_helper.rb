# frozen_string_literal: true
module ApplicationHelper
  def render_with_format(format, *args)
    old_formats = formats
    self.formats = [format]
    output = render(*args)
    self.formats = old_formats
    output
  end

  def xml_safe(string)
    string.gsub(/[^ [^[:cntrl:]] | [\s] ]/, '')
  end

  def inline_asset(name)
    path = asset_path('application.css')
    Rails.cache.fetch(path) { File.read(Rails.root.join('public', URI(path).path[1..-1])) }.html_safe
  end

  def visitors_cache(*args, &block)
    if current_user
      yield
    else
      cache(*args, &block)
    end
  end

  def game_author_page_url(game)
    if game.author == game.user.username
      user_url(game.author)
    else
      search_url(search: { author: game.author })
    end
  end

  def game_author_page_path(game)
    if game.author == game.user.username
      user_path(game.author)
    else
      search_path(search: { author: game.author })
    end
  end

  def genre_options
    Genre.all.map do |genre|
      [genre.to_translated_s, genre.id]
    end
  end

  # i18n-tasks-use t('date.formats.default')
  # i18n-tasks-use t('date.formats.short_date')
  # i18n-tasks-use t('time.formats.default')

  def toggle_button_to(on_title, off_title, url, options = {})
    on_options = {
      'data-remote' => true,
      'data-type' => 'script',
      'data-method' => 'PUT',
      'data-analytics-click' => 'Game Subscribed',
      'rel' => 'nofollow',
      class: options[:on]
    }

    off_options = {
      'data-remote' => true,
      'data-type' => 'script',
      'data-method' => 'DELETE',
      'data-analytics-click' => 'Game Unsubscribed',
      'rel' => 'nofollow',
      class: options[:off]
    }

    on_link = link_to(on_title, url, on_options)
    off_link = link_to(off_title, url, off_options)

    on_link << off_link
  end

  def menu_element(options = {})
    selected = options[:selected] ? 'selected' : ''

    content_tag(:li, class: selected) do
      yield
    end
  end

  def amp_image_tag(url, options = {})
    options[:width], options[:height] = *safely_extract_image_size(url) unless options[:width]
    content_tag('amp-img', nil, options.merge(src: asset_url(url)))
  end

  def render_with_block(*args, &block)
    options = args.last
    if options.is_a? Hash
      options[:block] = block
    else
      args << { block: block }
    end
    render(*args)
  end

  def page_title(title)
    text = title
    # text = "(#{current_user.notifications_count}) #{text}" if current_user&.notifications_count.to_i > 0
    content_for(:title) { text }
    pjax_request? ? content_tag('title', "#{text} - Free Indie Games") : ''
  end

  private

  def safely_extract_image_size(url)
    FastImage.size(asset_url(url), :raise_on_failure => true)
  rescue StandardError => e
    Rails.env.development? ? raise(e) : Rails.logger.warn(e)
    [640, 480]
  end
end
