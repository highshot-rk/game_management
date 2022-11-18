class AddUnreadToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :unread, :boolean, default: true
  end
end
