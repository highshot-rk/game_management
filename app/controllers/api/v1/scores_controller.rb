# frozen_string_literal: true
class Api::V1::ScoresController < Api::V1::ApiController
  def index
    # @scores = current_game
    #           .scores
    #           .where(name: params[:name])
    #           .order(value: :desc).page(params[:page])
    @scores = current_game
              .scores
              .order(value: :desc).page(params[:page])
    render json: {
      scores: @scores.map { |e| { score: e.value, user: e.user.username } }
    }
  end

  def show
    @score = current_game.scores.find_by(user: current_api_user) || Score.new

    render json: {
      score: @score.value || 0,
      achieved_at: @score.updated_at || Date.new(0)
    }
  end

  def create
    run :update, update_params, params.require(:score)
    render json: {
      success: true
    }
  rescue ScoresService::NotIncreasingError
    render json: {
      success: false
    }
  rescue ScoresService::UpdateError => e
    render json: {
      success: false,
      error: e.record.errors
    }, status: 422
  end

  private

  def update_params
    { game: current_game, user: current_api_user }
    # { game: current_game, user: current_api_user, name: params[:name] }
  end
end
