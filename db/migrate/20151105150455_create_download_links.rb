class CreateDownloadLinks < ActiveRecord::Migration
  def change
    create_table :download_links do |t|
      t.string :url
      t.boolean :broken, null: false, default: false
      t.boolean :play_online, null: false, default: false
      t.integer :downloads_count, null: false, default: 0
      t.references :game, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_attachment :download_links, :file

    create_table :platform_links do |t|
      t.references :download_link, index: true, null: false, foreign_key: true
      t.references :platform, index: true, null: false, foreign_key: true
    end

    add_index :platform_links, [:download_link_id, :platform_id],
              unique: true
  end
end
