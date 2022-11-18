class RatingsController < ApplicationController
  before_action :authenticate_user!

  def update
    run :update, update_params, score
    render json: { mean: @game.reload.ratings_avg }
  rescue RatingsService::UpdateError
    render
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def update_params
    { user: current_user, game: game }
  end

  def score
    params.require(:score)
  end
end
