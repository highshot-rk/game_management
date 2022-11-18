class SupportersController < ApplicationController
  def create
    @supporter = Supporter.new
    @supporter.user_id = current_user.id
    @supporter.prize = params[:prize].to_i
    @supporter.game_id = params[:game_id]
    @supporter.save
  end

  def update
    @supporter = Supporter.find(params[:supporter_id])
    @supporter.update(confirmed: true)
    @supporter.create_activity :update, owner: current_user, recipient: @supporter.user, key: "user.prize"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @supporter = Supporter.find(params[:supporter_id])
    @supporter.destroy
    redirect_back(fallback_location: root_path)
  end
end
