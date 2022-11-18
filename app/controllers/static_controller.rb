class StaticController < ApplicationController
  def license
    render layout: 'static'
  end

  def about
    @games = Game.downloaded_today.includes(:screen, :online_links).limit(6).decorate
    render layout: 'application'
  end

  def faq
    render layout: 'application'
  end

  def developers
    render layout: 'application'
  end
end
