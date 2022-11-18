class AddNotificationSoundToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :notification_sound, :boolean, default: true
  end
end
