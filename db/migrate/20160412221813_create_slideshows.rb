class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :slideshows do |t|
      t.text :url, null: false
      t.timestamps null: false
    end
    add_attachment :slideshows, :image
  end
end
