class AddLastNewsAtToGames < ActiveRecord::Migration[5.0]
  def up
    add_column :games, :last_news_at, :datetime
    say_with_time 'populating last_news_at' do
      Game.find_each do |game|
        game.update_columns(last_news_at: game.last_news&.created_at)
      end
    end
  end

  def down
    remove_column :games, :last_news_at
  end
end
