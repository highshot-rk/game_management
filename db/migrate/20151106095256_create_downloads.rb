class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.references :download_link, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :count, null: false, default: 1
      t.timestamps null: false
    end
    add_index :downloads, [:download_link_id, :user_id], unique: true
    remove_column :downloads, :updated_at
  end
end
