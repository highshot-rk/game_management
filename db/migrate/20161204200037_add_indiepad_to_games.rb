# frozen_string_literal: true
class AddIndiepadToGames < ActiveRecord::Migration
  def change
    add_column :games, :indiepad, :boolean, default: false
  end
end
