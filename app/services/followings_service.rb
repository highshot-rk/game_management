# frozen_string_literal: true

class FollowingsService < BaseService
  include ScoreAssigner
  include NotificationSender

  score :following

  class UpdateError < BaseService::Error; end

  def updated!(following)
    notify!(following, 'create', from: following.user, to: [following.game_user])
    score!(following, :create)
  end

  def destroyed!(following)
    score!(following, :destroy)
  end

private

  def score!(following, action)
    return unless following.user != following.game_user

    assign_score(following.user, action)
    assign_score(following.game_user, action)
  end
end
