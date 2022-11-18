module NotificationSender
  extend ActiveSupport::Concern

  def notify!(subject, type, from: nil, to: [], scope: nil, params: {}, allow_self: false)
    return if notification_excluded?(subject, type)

    to.each do |recipient|
      activity = subject.create_activity type, owner: from, recipient: recipient, parameters: params
      NotificationRelayJob.perform_now(recipient.id)
      PublicActivitiesMailer.notify(activity).deliver_later if can_send?(recipient, activity, scope, allow_self)
    end
  end

  private

  def notification_excluded?(model, type)
    ENV.fetch('SKIP_NOTIFICATIONS', '').split(',').include?("#{model.model_name.plural}.#{type}")
  end

  def send_allowed?(user, activity, scope)
    user.current_settings.can_receive_mail?(activity.key, scope)
  rescue Setting::InvalidKeyError => e
    raise e unless Rails.env.production?

    Raven.capture_exception(e) if defined?(Raven)
  end

  def excluded?(activity, scope)
    excluded = Settings.public_activity.mailer.exclusions
    excluded.activity_keys.any? { |e| activity.key.include?(e) } ||
      excluded.scopes.any? { |e| scope.to_s.include?(e) }
  end

  def can_send?(user, activity, scope, allow_self)
    !excluded?(activity, scope) && send_allowed?(user, activity, scope) && (user != activity.owner || allow_self)
  end
end
