class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :downloads, null: false, default: 0
      t.integer :visits, null: false, default: 0
      t.date :created_at, null: false
    end
    add_index :stats, [:game_id, :created_at], unique: true
  end
end
