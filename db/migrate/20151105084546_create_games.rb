class CreateGames < ActiveRecord::Migration
  def up
    # execute <<-SQL
    #   CREATE TYPE game_type AS ENUM ('complete', 'demo', 'minigame');
    # SQL
    create_table :games do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.integer :release_type, null: false, default: 0

      t.references :user, index: true, foreign_key: true

      t.string :website
      t.string :author, null: false

      # Temporary storing variables
      t.references :screen

      t.float :ratings_avg, null: false, default: 0
      t.float :ratings_abs, null: false, default: 0
      t.integer :ratings_count, null: false, default: 0
      t.integer :screens_count, null: false, default: 0
      t.integer :artworks_count, null: false, default: 0
      t.integer :downloads_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.integer :news_count, null: false, default: 0
      t.integer :visits_count, null: false, default: 0
      t.integer :followings_count, null: false, default: 0

      t.timestamps null: false
    end
    add_index :games, :screen_id, unique: true
    add_index :games, :author
    add_index :games, :slug, unique: true
    # add_column :games, :release_type, :game_type, null: false, index: true
  end

  def down
    drop_table :games
    # execute <<-SQL
    #   DROP TYPE game_type;
    # SQL
  end
end
