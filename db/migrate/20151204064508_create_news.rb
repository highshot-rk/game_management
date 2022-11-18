class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.text :text, null: false
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps null: false
    end
  end
end
