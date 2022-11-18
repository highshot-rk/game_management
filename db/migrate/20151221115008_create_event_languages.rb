class CreateEventLanguages < ActiveRecord::Migration
  def change
    create_table :event_languages do |t|
      t.references :event, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
    end
    add_index :event_languages, [:event_id, :language_id], unique: true
  end
end
