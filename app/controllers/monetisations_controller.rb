class MonetisationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = Game.find(params[:game_id]).decorate
    @monetisation = Monetisation.create(monetisation_params)
    @monetisation.game_id = @game.id
    @game.monetisation = @monetisation
    @monetisation.save
    redirect_back(fallback_location: root_path)
  end

  def update
    @monetisation = Monetisation.find(params[:id])
    @monetisation.update_attributes(monetisation_params)
    redirect_back(fallback_location: root_path)
  end

  private

  def monetisation_params
    params.require(:monetisation).permit(:paypal_account, :description, :prize_one_file, :prize_two_file)
  end
end
