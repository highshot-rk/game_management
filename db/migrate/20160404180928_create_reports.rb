class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :download_link, null: false, index: true, foreign_key: true
      t.integer :reason, null: false, default: 0
      t.text :message
      t.boolean :resolved, null: false, default: false
      t.timestamps null: false
    end
  end
end
