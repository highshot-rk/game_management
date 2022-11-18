class PublicActivitiesController < ApplicationController
  before_action :authenticate_user!
  after_action :mark_as_read, only: :index, if: :get_read?

  def index
    @activities = PublicActivity::Activity
                  .includes(:trackable, :owner)
                  .where(recipient: current_user)
                  .where("NOT (owner_id = ? AND (key = ? OR key = ?))", current_user.id, 'comment.create', 'following.create')
                  .order(created_at: :desc)

    if !get_read?
      @activities = @activities.limit(8)
    else
      @unread_activities = @activities.where(unread: true)
      @activities = @activities.where(unread: false).limit(2)
    end

    render layout: false
  end

  def show
    if params[:id]
      @activities = PublicActivity::Activity
                    .includes(:trackable, :owner)
                    .where(recipient: current_user)
                    .where('id < ?', params[:id])
                    .where("NOT (owner_id = ? AND (key = ? OR key = ?))", current_user.id, 'comment.create', 'following.create')
                    .order(created_at: :desc).limit(8)

      current_user.activities.order(created_at: :desc).last.id == @activities.last.id ? (@is_last = 0) : (@is_last = 1)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @activities = PublicActivity::Activity
                  .where(recipient: current_user)
    @activities = @activities.where(id: params[:id]) unless get_all?
    @activities.map(&:destroy)
  end

  private

  def get_all?
    params[:id] == 'all'
  end

  def get_read?
    get_all? || current_user.has_unread_notifications?
  end

  def mark_as_read
    User.update_counters(current_user.id, notifications_count: -@unread_activities.count)
    @unread_activities.update_all(unread: false)
  end
end
