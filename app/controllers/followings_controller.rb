class FollowingsController < ApplicationController
  before_action :authenticate_user!

  before_action :following, only: :destroy
  before_action :game

  respond_to :html, :js

  def update
    @following = Following.where(following_params).first_or_initialize
    new_record = @following.new_record?

    respond_to do |format|
      if @following.save
        format.js do
          @action = :updated
          @followings_count = game.followings.count

          FollowingsService.new().updated!(@following) if new_record
          render(template: 'games/following.js.erb', layout: false)
        end
      else
        format.html do
          flash[:error] = 'Oops! There was a problem subscribing to the Game. Please try again or get in touch if the problem persists.'
          redirect_to(game_path(game.slug))
        end

        # Ensure we log the error, if there is one.
        #
        Rails.logger.error(@following.errors.full_messages.to_sentence) if Rails.env.development?
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.warn("Duplicate following: #{e}")
  end

  def destroy
    respond_to do |format|
      if following.destroy
        format.js do
          @action = :destroyed
          @followings_count = game.followings.count

          FollowingsService.new().destroyed!(following)
          render(template: 'games/following.js.erb', layout: false)
        end
      else
        format.html do
          flash[:error] = 'Oops! There was a problem unsubscribing from the Game. Please try again or get in touch if the problem persists.'
          redirect_to(game_path(game.slug))
        end

        # Ensure we log the error, if there is one.
        #
        Rails.logger.error(following.errors.full_messages.to_sentence) if Rails.env.development?
      end
    end
  end

private

  def following
    @following ||= Following.find_by!(following_params)
  end

  def following_params
    { user: current_user, game: game }
  end

  def game
    @game ||= Game.find(params[:game_id])
  end
end
