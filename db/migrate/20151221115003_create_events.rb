class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :rules
      t.text :prizes
      t.text :website
      t.integer :event_type, null: false, default: 0
      t.datetime :start, null: false
      t.datetime :end, null: false
      t.references :user, null: false
      t.timestamps null: false
    end
    add_attachment :events, :screen
  end
end
