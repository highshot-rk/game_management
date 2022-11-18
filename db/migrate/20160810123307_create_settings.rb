class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.json :data
    end
    add_index :settings, :user_id, unique: true
  end
end
