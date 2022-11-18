class AddNewFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :surname, :string
    add_column :users, :phone_number, :string
  end
end
