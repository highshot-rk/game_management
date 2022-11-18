class RatingsService < BaseService
  class UpdateError < BaseService::Error; end
  include ScoreAssigner
  include NotificationSender
  score :rating

  def update(score)
    @rating = Rating.where(params).first_or_initialize
    if legacy_vote?(@rating)
      @rating.rating = score
      return
    end
    was_new_record = @rating.new_record?
    @rating.rating = score
    fail UpdateError unless @rating.save
    after_create @rating if was_new_record
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.warn("Duplicate following: #{e}")
  end

  def output
    @rating
  end

  private

  def legacy_vote?(rating)
    rating.persisted? && rating.legacy?
  end

  def after_create(rating)
    send_update_notifications(rating)
    assign_score rating.user, :create if rating.user != rating.game.user
    assign_score rating.game.user, :create if rating.user != rating.game.user
  end

  def send_update_notifications(rating)
    notify! rating, 'create', from: rating.user, to: [rating.game.user] if rating.user != rating.game.user
  end
end
