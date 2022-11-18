PublicActivity::Activity.class_eval do
  after_commit on: [:create, :destroy] do |model|
    if model.recipient.is_a?(User)
      if model.persisted?
        User.update_counters(model.recipient.id, notifications_count: 1)
      else
        User.update_counters(model.recipient.id, notifications_count: -1)
      end
    end
  end
end
