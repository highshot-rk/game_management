# frozen_string_literal: true
class Api::V1::ApiController < ApplicationController
  include CorsConcern
  skip_before_action :verify_authenticity_token
  before_action :set_cors_headers
  before_action :authorize_code!

  protected

  def current_api_user
    @current_user ||= @code.user
  end

  def current_game
    @current_game ||= @code.game
  end

  def authorize_code!
    @code = AuthCode.find_by(token: api_token)
    return render json: { error: 'Invalid token' }, status: 403 unless @code
    if @code.expired?
      @code.destroy
      render json: { error: 'Token expired' }, status: 403
    else
      @code.update_column(:expires_at, 3.months.from_now)
    end
  end

  def api_token
    params[:token] || bearer
  end

  def bearer
    (request.headers['Authentication'] || '').split('bearer ').last
  end
end
