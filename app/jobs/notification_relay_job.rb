class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(user)
    ActionCable.server.broadcast "notifications:#{user}", { count: 1 }
  end
end
