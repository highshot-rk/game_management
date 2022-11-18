class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notification_count = current_user.notifications.where(unread: true).where("NOT (owner_id = ? AND (key = ? OR key = ?))", current_user.id, 'comment.create', 'following.create').count
    render json: { count: @notification_count }
  end

  def read_all
    @notifications = current_user.notifications.where(unread: true)
    @notifications.update_all(unread: false)
  end
end
