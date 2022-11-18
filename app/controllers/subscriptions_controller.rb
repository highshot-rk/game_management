class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :js

  def update
    run :update, subscription_params
  rescue SubscriptionsService::UpdateError
    error = @service.output.errors.full_messages.to_sentence
    render text: error, status: :unprocessable_entity
  end

  def destroy
    run :destroy, subscription_params, subscription
  rescue SubscriptionsService::UpdateError
    error = @service.output.errors.full_messages.to_sentence
    render text: error, status: :unprocessable_entity
  end

  private

  def subscription
    @subscription ||= EventSubscription.find_by!(subscription_params)
  end

  def subscription_params
    { user: current_user, event: event }
  end

  def event
    @event ||= Event.find(params[:event_id])
  end
end
