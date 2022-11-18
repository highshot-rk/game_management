class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :genres, :name, unique: true
    add_reference :games, :genre, index: true, null: false, foreign_key: true
  end
end
