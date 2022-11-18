class SubscriptionsService < BaseService
  class UpdateError < BaseService::Error; end
  include ScoreAssigner
  include NotificationSender
  score :event

  def update
    @subscription = EventSubscription.where(params).first_or_initialize
    was_new_record = @subscription.new_record?
    fail UpdateError unless @subscription.save
    post_create_actions @subscription if was_new_record
  end

  def destroy(subscription = nil)
    @subscription = subscription || subscription.find_by!(params)
    fail DestroyError unless @subscription.destroy
    assign_score @subscription.user, :destroy
  end

  def output
    @subscription
  end

  private

  def post_create_actions(subscription)
    assign_score subscription.user, :create
    notify_event_author(subscription)
  end

  def notify_event_author(subscription)
    notify! subscription, 'create', from: subscription.user, to: [subscription.event_user]
  end
end
