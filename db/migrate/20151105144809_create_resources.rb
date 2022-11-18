class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :type, null: false
      t.text :url
      t.references :game, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_attachment :resources, :file
  end
end
