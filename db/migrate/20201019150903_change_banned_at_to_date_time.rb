class ChangeBannedAtToDateTime < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :banned_at

    add_column :users, :banned_at, :datetime
  end
end
