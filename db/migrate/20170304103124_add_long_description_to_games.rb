class AddLongDescriptionToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :long_description, :text
  end
end
