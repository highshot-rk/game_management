class AddTokenToGameAndUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_index :users, :token, unique: true

    add_column :games, :token, :string
    add_index :games, :token, unique: true
  end
end
