class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :game, index: true, null: false, foreign_key: true
      t.float :rating, null: false, default: 0
      t.timestamps null: false
    end
    add_index :ratings, [:user_id, :game_id],
              unique: true
  end
end
