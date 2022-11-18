class AddAdultContentToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :adult_content, :boolean, default: false
  end
end
