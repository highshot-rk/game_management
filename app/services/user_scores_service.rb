# frozen_string_literal: true
class UserScoresService < BaseService
  class UpdateError < BaseService::Error; end
  class RecalculateError < BaseService::Error; end

  def update
    old_level = user.level
    User.update_counters(user.id, score: delta_score)
    send_score_notification(user, delta_score) if delta_score > 0
    send_level_up_notification(user) if old_level < user.reload.level
  end

  def recalculate(user)
    @user = user
    total_score = Settings.scores
                          .map { |key, score| calculate_total_score(user, key).to_i * score }
                          .inject(:+)

    fail RecalculateError unless user.update_column(:score, total_score)
  end

  def output
    @user
  end

  private

  def send_score_notification(user, delta_score)
    user.create_activity action: 'score', parameters: { delta: delta_score }, recipient: user
    NotificationRelayJob.perform_now(user.id)
  end

  def send_level_up_notification(user)
    user.create_activity action: 'level', parameters: { level: user.level }, recipient: user
    NotificationRelayJob.perform_now(user.id)
  end

  def calculate_total_score(user, key)
    {
      download: user.downloads.count,
      login: 0,
      rating: user.ratings.count,
      comment: user.comments.count,
      following: user.followed.count,
      event: user.event_subscriptions.count,
      medal: user.game_medals.count,
      game: user.games.count
    }[key]
  end

  def user
    @user ||= params[:user]
  end

  def delta_score
    @delta_score ||= begin
      if params[:status] == :create
        Settings.scores[params[:action]]
      else
        -Settings.scores[params[:action]]
      end
    end
  end
end
