class NewsController < ApplicationController
  include SuggestionsProvider

  suggestions on: [:index]
  before_action :authenticate_user!, except: [:index]

  before_action :game, only: [:create, :destroy]
  before_action :news, only: [:destroy]

  def index
    @news = game.news
      .includes(:user)
      .latest
      .page(params[:page])

    render(layout: pjax_request? ? nil : 'game')
  end

  def create
    authorize(game, :manage?)

    @news = News.new(news_params)
    @news.assign_attributes(
      user: current_user,
      game: game
    )

    respond_to do |format|
      if @news.save
        @news_count = game.news.count
        NewsService.new().created!(@news)
      else
        # Ensure we log the error, if there is one.
        Rails.logger.error(@news.errors.full_messages.to_sentence) if Rails.env.development?
      end
      format.html { redirect_to(game_news_path(game.slug)) }
      format.js
    end
  end

  def destroy
    authorize(news)

    respond_to do |format|
      if news.destroy
        format.html { redirect_to(game_news_path(game.slug)) }
        format.js do
          @news_count = game.news.count
        end
      else
        format.html do
          flash[:error] = 'Oops! There was a problem deleting the News article. Please try again or get in touch if the problem persists.'
          redirect_to(game_news_path(game.slug))
        end
      end
    end
  end

private

  def news_params
    params.require(:news).permit(:text)
  end

  def news
    @news ||= News.find(params[:id])
  end

  def game
    @game ||= Game.find(params[:game_id]).decorate
  end
end
