class CreateMedals < ActiveRecord::Migration
  def change
    create_table :medals do |t|
      t.string :key, length: 10
      t.integer :score
      t.timestamps
      t.references :game, index: true
      t.references :user, index: true
    end
    add_index :medals, :key
    add_index :medals, [:key, :game_id, :user_id], unique: true
  end
end
