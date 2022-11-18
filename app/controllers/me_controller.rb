class MeController < ApplicationController
  before_action :authenticate_user!

  def games
    @games = current_user.games.includes(:screen, :online_links)
             .page(params[:page]).decorate
  end

  def followed_games
    @games = current_user.followed_games.includes(:screen, :online_links)
             .page(params[:page]).decorate
  end

  def event_subscriptions
    @events = current_user.subscribed_events
              .page(params[:page]).decorate
  end
end
