# frozen_string_literal: true
class ScoresService < BaseService
  class NotIncreasingError < BaseService::Error; end
  class UpdateError < BaseService::Error; end

  def update(score)
    @old_leader = params[:game]&.max_score&.user
    score = score.to_i
    ActiveRecord::Base.transaction do
      @score = Score.where(params).first_or_initialize
      fail NotIncreasingError unless score > @score.value
      fail UpdateError, @score unless @score.update(value: score)
    end
    after_create @score
  end

  private

  def after_create(score)
    NewLeaderJob.perform_later(@old_leader, score.game)
    send_update_notifications(score)
  end

  def send_update_notifications(_rating)
  end
end
