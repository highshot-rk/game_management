class AddFileProcessingToResource < ActiveRecord::Migration
  def change
    add_column :resources, :file_processing, :boolean
  end
end
