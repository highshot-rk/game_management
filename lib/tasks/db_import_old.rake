def uri?(value)
  uri = URI.parse(value)
  uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
rescue URI::InvalidURIError
  false
end

def split_attribute(attribute)
  attribute.to_s.split(',')
    .reject(&:blank?).map { |e| e.to_i + 1 }
end

namespace :db do
  desc 'Dumps the database to backups'
  task import_old: :environment do
    require 'mysql2'
    ['db:drop', 'db:create', 'db:migrate'].each do |task|
      break unless Rake::Task[task].invoke
    end
    Language.create!([
      { name: 'Italiano', locale: 'it' },
      { name: 'English', locale: 'en' },
      { name: 'Deutsch', locale: 'de' },
      { name: 'Espanol', locale: 'es' },
      { name: 'Francais', locale: 'fr' },
      { name: 'Portugues', locale: 'pt' }])

    Tool.create!([
      { name: 'Unknown' },
      { name: 'Other' },
      { name: 'Adventure Game Studio' },
      { name: 'Construct 2' },
      { name: 'Construct classic' },
      { name: 'Custom' },
      { name: 'Easy RPG' },
      { name: 'Eclipse Origin' },
      { name: 'Engine001' },
      { name: 'Game Maker' },
      { name: 'IG Maker' },
      { name: 'Ika' },
      { name: 'Multimedia Fusion' },
      { name: 'Multimedia Fusion 2' },
      { name: 'OHRRPGCE' },
      { name: 'Renpy' },
      { name: 'Rpg Maker 2000' },
      { name: 'Rpg Maker 2003' },
      { name: 'Rpg Maker 95' },
      { name: 'Rpg Maker XP' },
      { name: 'Rpg Maker VX' },
      { name: 'Rpg Maker VX ACE' },
      { name: 'Rpg Maker MV' },
      { name: 'Rpg Toolkit' },
      { name: 'Sim Rpg Maker 95' },
      { name: 'Sphere' },
      { name: 'Super Mario Bors X' },
      { name: 'Unity' },
      { name: 'Verge 3' },
      { name: 'Zelda Classic' },
      { name: 'Ogre 3D' },
      { name: '3D Rad' },
      { name: 'Mugen' },
      { name: '3D Adventure Studio' },
      { name: 'Unreal Engine' }])

    Platform.create!([
      { name: 'pc' },
      { name: 'web' },
      { name: 'Linux' },
      { name: 'osx' },
      { name: 'android' },
      { name: 'Ios' },
      { name: 'Windows phone' },
      { name: 'HTML5' }])

    Genre.create!([
      { name: 'Rpg' },
      { name: 'BrowserGame' },
      { name: 'Platform/Action' },
      { name: 'Shoot em up' },
      { name: 'Puzzle' },
      { name: 'Point and Click' },
      { name: 'Sport' },
      { name: 'Fighting' },
      { name: 'Other' }])

    client = Mysql2::Client.new(
      host: 'localhost', username: 'root',
      database: 'freankexpo', symbolize_keys: true)

    schema_info = client.query("SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'freankexpo' AND TABLE_NAME = 'users';")

    users = client.query('SELECT * FROM users')

    ActiveRecord::Base.transaction do
      users.each do |user|
        begin
          user[:id] = 7 if user[:id].to_i == 0
          u = User.new(id: user[:id], username: user[:username],
                       email: user[:email], password: user[:password],
                       legacy_password: user[:password])
          u.skip_confirmation!
          u.save!
        rescue ActiveRecord::RecordInvalid => e
          puts 'SKIPPED!!!'
          puts e.record.errors.inspect
          next
        end
      end
    end
    ActiveRecord::Base.connection.execute "ALTER SEQUENCE users_id_seq RESTART WITH #{schema_info.to_a[0][:AUTO_INCREMENT]};"

    games = client.query('SELECT * FROM games')

    ActiveRecord::Base.transaction do
      games.each do |game|
        begin
          game[:userid] = 7 if game[:userid].to_i == 0
          if game[:website] == '0' || game[:website].blank?
            game[:website] = nil
          elsif !uri?(game[:website])
            game[:website] = "http://#{game[:website]}"
          end
          game[:website] = nil unless uri?(game[:website])

          game[:description] = 'No description...' if game[:description].blank?
          g = Game.create!(
            id: game[:id], title: game[:name], author: game[:author],
            description: strip_slashes(game[:description]),
            website: game[:website],
            release_type: game[:status],
            created_at: game[:date],
            user_id: game[:userid],
            ratings_count: game[:rates],
            ratings_abs: game[:absrate],
            ratings_avg: game[:rating],
            tool_id: game[:tool].to_i + 1,
            genre_id: game[:genre].to_i + 1,
            downloads_count: game[:downloads],
            download_links_attributes: [
              { url: game[:link], broken: game[:broken],
                platform_ids: split_attribute(game[:system])
              }],
            videos_attributes: [{ url: game[:video] }],
            language_ids: split_attribute(game[:lang])
          )
          g.download_links.first.downloads.create!(
            count: game[:downloads], user_id: nil)
        rescue ActiveRecord::RecordInvalid => e
          puts 'skipped'
          puts e.record.errors.inspect
        end
      end
    end

    schema_info = client.query("SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'freankexpo' AND TABLE_NAME = 'games';")

    ActiveRecord::Base.connection.execute "ALTER SEQUENCE games_id_seq RESTART WITH #{schema_info.to_a[0][:AUTO_INCREMENT]};"

    favourites = client.query('SELECT * FROM favorites')

    favourites.each do |favourite|
      begin
        Following.create!(
          game_id: favourite[:game_id], user_id: favourite[:user_id])
      rescue ActiveRecord::RecordInvalid => e
        puts 'skipped'
        puts e.record.inspect
        puts e.record.errors.inspect
      end
    end

    # Rating.skip_callback(:create)
    users.each do |user|
      user[:rated].to_s.split('-').reject(&:blank?).each do |rated|
        begin
          game = Game.find(rated)
          r = Rating.new(
            user_id: user[:id], game_id: game.id, rating: game.ratings_avg)
          r.validate!
          query = ActiveRecord::Base
                  .send(:sanitize_sql_array,
                       ["INSERT INTO ratings (user_id, created_at, updated_at, game_id, rating) VALUES (?, ?, ?, ?, ?)",
                        r.user_id, 3.years.ago, Time.now, game.id, game.ratings_avg])
          ActiveRecord::Base.connection.execute(query)
        rescue ActiveRecord::RecordNotFound => e
          puts 'skipped'
          puts 'game not found'
          puts e.inspect
        rescue ActiveRecord::RecordInvalid => e
          puts 'skipped'
          puts e.record.errors.inspect
        end
      end
    end
    # Rating.set_callback(:create)

    comments = client.query('SELECT * FROM comments')

    comments.each do |comment|
      begin
        user_id = User.find_by(username: comment[:from]).try(:id) || 7
        Comment.create!(id: comment[:id], game_id: comment[:gameid],
                        created_at: comment[:time], updated_at: comment[:time],
                        text: comment[:comment], user_id: user_id)
      rescue ActiveRecord::RecordInvalid => e
        puts 'skipped'
        puts e.record.errors.inspect
      end
    end
    schema_info = client.query("SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'freankexpo' AND TABLE_NAME = 'comments';")
    ActiveRecord::Base.connection.execute "ALTER SEQUENCE comments_id_seq RESTART WITH #{schema_info.to_a[0][:AUTO_INCREMENT]}"

    news = client.query('SELECT * FROM news')

    news.each do |news_element|
      begin
        game = Game.find(news_element[:gameid])
        user_id = game.user_id
        News.create!(
          text: news_element[:news],
          created_at: news_element[:time], game_id: game.id, user_id: user_id
        )
      rescue ActiveRecord::RecordNotFound => e
        puts 'skipped'
        puts 'game not found'
        puts e.inspect
      rescue ActiveRecord::RecordInvalid => e
        puts 'skipped'
        puts e.record.errors.inspect
      end
    end

    # stats = client.query('SELECT * FROM stats')

    # ActiveRecord::Base.transaction do
    #   stats.each do |stat|
    #     begin
    #       Stat.create!(
    #         created_at: stat[:date], game_id: stat[:id],
    #         visits: stat[:visits], downloads: stat[:downloads])
    #     rescue ActiveRecord::RecordInvalid => e
    #       puts 'skipped'
    #       puts e.record.errors.inspect
    #     end
    #   end
    # end

    # ActiveRecord::Base.transaction do
    #   stats.each do |stat|
    #     begin
    #       Game.find(stat[:id])
    #       query = ActiveRecord::Base
    #               .send(:sanitize_sql_array,
    #                    ["INSERT INTO visits (count, created_at, game_id) VALUES (?, ?, ?)",
    #                     stat[:visits], stat[:date], stat[:game_id]])
    #       ActiveRecord::Base.connection.execute(query)
    #       # Visit.create!(
    #       #   count: stat[:visits], created_at: stat[:date], game_id: stat[:id])
    #     rescue ActiveRecord::RecordNotFound => e
    #       puts 'skipped'
    #       puts 'game not found'
    #       puts e.inspect
    #     rescue ActiveRecord::RecordInvalid => e
    #       puts 'skipped'
    #       puts e.record.errors.inspect
    #     end
    #   end
    # end

    stats_by_game = client.query('SELECT id, count(visits) as visits_count '\
                                 'FROM stats GROUP BY id')

    ActiveRecord::Base.transaction do
      stats_by_game.each do |stat|
        begin
          Game.find(stat[:id])
            .update_attribute(:visits_count, stat[:visits_count])
        rescue ActiveRecord::RecordNotFound => e
          puts 'skipped'
          puts 'game not found'
          puts e.inspect
        end
      end
    end
  end
end

def strip_slashes(string)
  string.gsub('\\\\', '\\')
    .gsub('\"', '"')
    .gsub("\\'", "'")
    .gsub('\n', "\n")
    .gsub('\r', "\r")
end
