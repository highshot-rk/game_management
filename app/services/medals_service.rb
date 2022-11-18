class MedalsService < BaseService
  class UpdateError < BaseService::Error; end
  class DestroyError < BaseService::Error; end
  include ScoreAssigner
  include NotificationSender
  score :medal

  def update(medal)
    @medal = medal
    return if @medal.persisted? && @medal.changed? # Optimization to avoid query

    @medal.score = params[:score]
    newly_assigned = @medal.new_record? || @medal.improved?
    already_assigned = @medal.already_assigned?
    fail UpdateError unless @medal.save
    after_create(@medal, newly_assigned, already_assigned)
  end

  def destroy(medal)
    @medal = medal
    return unless @medal.persisted? # Optimization
    was_persisted = @medal.persisted?
    fail DestroyError unless @medal.destroy
    assign_score medal_owner(medal), :destroy if was_persisted
  end

  private

  def after_create(medal, newly_assigned, already_assigned)
    send_create_notification(medal) if newly_assigned
    assign_score medal_owner(medal), :create if newly_assigned && !already_assigned
  end

  def send_create_notification(medal)
    if medal.user
      notify! medal, 'create', from: medal.user, to: [medal.user]
    else
      notify! medal, 'create', from: medal.game, to: [medal.game.user]
    end
  end

  def medal_owner(medal)
    medal.user || medal.game.user
  end
end
