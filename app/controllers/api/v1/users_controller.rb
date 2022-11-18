# frozen_string_literal: true
class Api::V1::UsersController < Api::V1::ApiController
  def show
    @user_score = current_game.scores.find_by(user: current_api_user) || Score.new

    render json: {
      username: current_api_user.username,
      score: @user_score.value
    }
  end
end
