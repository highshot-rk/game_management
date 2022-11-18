# frozen_string_literal: true
class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.belongs_to :game, foreign_key: true, null: false, index: true
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.string :name
      t.integer :value, default: 0, null: false, index: true

      t.timestamps null: false
    end
    add_index :scores, [:user_id, :game_id, :name], unique: true
  end
end
