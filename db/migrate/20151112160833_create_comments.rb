class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :game, null: false, foreign_key: true, index: true
      t.text :text, null: false
      t.timestamps null: false
    end
  end
end
