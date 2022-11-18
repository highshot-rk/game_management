class EventDecorator < Draper::Decorator
  delegate_all

  def image(size = :medium)
    asset_url(screen_url(size).presence || 'Files/NoScreen.png')
  end

  def seo_description
    @seo_description ||= truncate("#{t('events.show.description')}: #{description}", separator: ' ', length: 160)
  end

  private

  delegate :t, to: :I18n

  def truncate(*args)
    ActionController::Base.helpers.truncate(*args)
  end

  def screen_url(size)
    screen.present? && screen.url(size)
  end

  def asset_url(*args)
    ActionController::Base.helpers.asset_url(*args)
  end
end