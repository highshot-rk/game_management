class GameDecorator < Draper::Decorator
  delegate_all

  def image(size = :medium)
    asset_url(screen_url(size).presence || 'Files/NoScreen.png')
  end

  def seo_description
    @seo_description ||= truncate(
      "#{t('activerecord.attributes.game.author')}: #{author} - "\
      "#{t('activerecord.attributes.game.genre')}: #{t("genres.genre.#{genre.name.downcase.gsub(/[^a-z]+/, '')}")} - "\
      "#{t('activerecord.attributes.game.description')}: #{description}",
      separator: ' ', length: 160)
  end

  private

  delegate :t, to: :I18n

  def screen_url(size)
    screen.try!(:file).try!(:url, size)
  end

  def truncate(*args)
    ActionController::Base.helpers.truncate(*args)
  end

  def asset_url(*args)
    ActionController::Base.helpers.asset_url(*args)
  end
end
