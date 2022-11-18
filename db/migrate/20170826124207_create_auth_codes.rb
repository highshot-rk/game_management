# frozen_string_literal: true
class CreateAuthCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_codes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :game, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end

    add_index :auth_codes, :token, unique: true
    add_index :auth_codes, [:user_id, :game_id]
  end
end
