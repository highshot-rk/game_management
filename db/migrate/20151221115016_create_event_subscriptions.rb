class CreateEventSubscriptions < ActiveRecord::Migration
  def change
    create_table :event_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.datetime :created_at, null: false
    end
    add_index :event_subscriptions, [:event_id, :user_id], unique: true
  end
end
