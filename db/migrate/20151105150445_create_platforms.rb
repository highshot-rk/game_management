class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    remove_column :platforms, :updated_at
    add_index :platforms, :name, unique: true
  end
end
