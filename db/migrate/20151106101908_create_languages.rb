class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.string :locale, length: 10, null: false
      t.timestamps null: false
    end
    remove_column :languages, :updated_at

    create_table :game_languages do |t|
      t.references :game, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
    end

    add_index :languages, :name, unique: true
    add_index :languages, :locale, unique: true
    add_index :game_languages, [:game_id, :language_id], unique: true
  end
end
