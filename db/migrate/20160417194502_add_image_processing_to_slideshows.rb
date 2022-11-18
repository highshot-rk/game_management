class AddImageProcessingToSlideshows < ActiveRecord::Migration
  def change
    add_column :slideshows, :image_processing, :boolean
  end
end
