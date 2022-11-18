class ErrorsController < ApplicationController
  def show
    @games = Game.downloaded_today.limit(6).decorate if status_code.to_i == 404
    render "#{status_code}.html", status: status_code
  end

  protected

  def status_code
    params[:code] || 500
  end
end
