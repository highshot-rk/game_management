class CommentsService < BaseService
  class CreateError < BaseService::Error; end
  include ScoreAssigner
  include NotificationSender

  score :comment

  def created!(comment)
    send_create_notifications(comment)

    assign_score(comment.user, :create) if comment.game_user != comment.user
    assign_score(comment.game_user, :create) if comment.user != comment.game_user
  end

  def destroyed!(comment)
    return unless comment.user != comment.game_user

    assign_score(comment.user, :destroy)
    assign_score(comment.game_user, :destroy)
  end

  private

  def send_create_notifications(comment)
    if comment.parent && (comment.parent.user != comment.user)
      notify!(comment, 'answer',
        from: comment.user,
        to: [comment.parent.user]
      )
    end

    /(?<=^|[\s.,]|\w[;'])(@([^\s.,]+))/.match(comment.text) do |match|
      user = User.where("LOWER(username) = ?", match[2].downcase).first
      if !user.nil?
        notify!(comment, 'mention',
          from: comment.user,
          to: [user]
        )
      end
    end

    notify_creation!(comment)
  end

  def notify_creation!(comment)
    followers = (comment.game.followings.includes(:user).map(&:user) - [comment.game_user] - [comment.user]).uniq

    return unless comment.parent.nil?

    notify!(comment, 'create',
      from: comment.user,
      to: [comment.game_user]
    )

    notify!(comment, 'follower_create',
      from: comment.user,
      to: followers
    )
  end
end