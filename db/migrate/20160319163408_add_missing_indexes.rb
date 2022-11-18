class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :events, :user_id
    add_index :news, :user_id
    add_index :news, :game_id
  end
end
