class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :tools, :name, unique: true
    add_reference :games, :tool, index: true, null: false, foreign_key: true
  end
end
