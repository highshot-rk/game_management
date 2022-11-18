class CreateSupporters < ActiveRecord::Migration[5.0]
  def change
    create_table :supporters do |t|
      t.references :user, foreign_key: true
      t.references :game, foreign_key: true
      t.integer :prize
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end
