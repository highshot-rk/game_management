class CreateIndiepadConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :indiepad_configs do |t|
      t.json :data, null: false
      t.belongs_to :game, foreign_key: true, index: false, null: false
    end
    add_index :indiepad_configs, :game_id, unique: true
  end
end
