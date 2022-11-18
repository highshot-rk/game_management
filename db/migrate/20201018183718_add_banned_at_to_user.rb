class AddBannedAtToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :banned_at, :time
  end
end
