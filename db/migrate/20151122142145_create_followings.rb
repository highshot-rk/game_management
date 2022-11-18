class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.timestamps null: false
    end
    remove_column :followings, :updated_at
    add_index :followings, [:game_id, :user_id], unique: true
  end
end
