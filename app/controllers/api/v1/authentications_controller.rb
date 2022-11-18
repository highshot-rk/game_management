# frozen_string_literal: true
class Api::V1::AuthenticationsController < ApplicationController
  include CorsConcern
  skip_before_action :verify_authenticity_token
  before_action :set_cors_headers, only: :create
  before_action :authenticate_user!, only: :show
  before_action :cleanup_old_codes!, only: :create

  # /api/token
  def show
    @user = current_user
    @user.update!(token: SecureRandom.urlsafe_base64(6))
    render plain: @user.token
  end

  # POST /api/token
  def create
    @code = AuthCode.create!(user: user, game: game)
    render json: {
      access_token: @code.token,
      expires_at: @code.expires_at
    }
  end

  private

  def cleanup_old_codes!
    AuthCode.where(user: current_user, game: game).expired.delete_all
  end

  def user
    @user ||= User.find_by!(token: params.require(:user_token))
  end

  def game
    @game ||= Game.find_by!(token: params.require(:game_key))
  end
end
