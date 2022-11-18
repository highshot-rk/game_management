class NewsService < BaseService
  class CreateError < BaseService::Error; end
  include NotificationSender

  def created!(news)
    send_create_notifications(news)
  end

private

  def send_create_notifications(news)
    notify!(news, 'create',
      from: news.user,
      to: news.game.followings.includes(:user).map(&:user).to_a.uniq,
      scope: :follower
    )
  end
end
