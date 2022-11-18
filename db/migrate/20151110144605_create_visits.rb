class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :user, index: true
      t.references :game, index: true
      t.integer :count, null: false, default: 1
      t.timestamps null: false
    end
    remove_column :visits, :updated_at
  end
end
