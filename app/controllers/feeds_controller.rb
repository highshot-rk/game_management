class FeedsController < ApplicationController
  def index
    respond_to do |format|
      format.html { render }
      format.rss { redirect_to feed_all_path(format: :rss, locale: nil) }
      format.xml { redirect_to feed_all_path(format: :xml, locale: nil) }
    end
  end

  def all
    @cache = Game.order(updated_at: :desc).first
    @games = Game.order(created_at: :desc).includes(:screen).limit(150).decorate
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'all.rss', layout: false }
    end
  end

  def all_yandex
    @cache = Game.order(updated_at: :desc).first
    @games = Game.order(created_at: :desc).includes(:screen).limit(50).decorate
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'all_yandex.rss', layout: false }
    end
  end

  def popular
    @cache = Rating.order(updated_at: :desc).first
    @games = Game.popular.includes(:screen).limit(150).decorate
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'popular.rss', layout: false }
    end
  end

  def last_updated
    @cache = News.order(created_at: :desc).first
    @games = Game.last_updated.includes(:screen).limit(150).decorate
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'last_updated.rss', layout: false }
    end
  end

  def events
    @cache = Event.order(created_at: :desc).first
    @events = Event.order(created_at: :desc).limit(150).decorate
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'events.rss', layout: false }
    end
  end

  def news
    @game = Game.find(params[:id])
    respond_to do |format|
      format.rss { render layout: false }
      format.xml { render 'news.rss', layout: false }
    end
  end
end
