class AddMobileFirstToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :mobile_first, :boolean, default: false
  end
end
