class UsersController < ApplicationController
  before_action :random_users, only: :show

  def show
    @user = User.find_by!('lower(username) = lower(?)', params[:id])
    @user_games = gather_data @user.authored_games.order(created_at: :desc)
    @followed_games = gather_data @user.followed_games.order('followings.created_at DESC')
    @commented_games =  gather_data @user.commented_games.order(created_at: :desc)
    @downloaded_games = gather_data @user.downloaded_games.order_by_download_date
    @played_score_games =  gather_data @user.played_score_games.order(created_at: :desc)
    @supported_games =  gather_data @user.supported_games.order(created_at: :desc)
  end

  def random_users
    @random_users = User.order("RANDOM()").limit(3).decorate
  end

  private

  def gather_data(games)
    (!current_user || !current_user.setting.present? || (current_user.setting.present? && !current_user.setting.adult_content)) ? games.not_adults.includes(:online_links, :screen).limit(6).decorate : games.includes(:online_links, :screen).limit(6).decorate
  end
end