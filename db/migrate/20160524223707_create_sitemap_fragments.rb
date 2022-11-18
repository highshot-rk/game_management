class CreateSitemapFragments < ActiveRecord::Migration
  def change
    create_table :sitemap_fragments do |t|
      t.text :content, null: false
      t.integer :fragmentable_id, null: false
      t.string  :fragmentable_type, null: false
      t.timestamps null: false
    end
    add_index :sitemap_fragments, [:fragmentable_id, :fragmentable_type], unique: true, name: :sitemap_fragmentable
  end
end
