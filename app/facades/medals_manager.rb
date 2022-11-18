class MedalsManager
  def initialize(game = nil, user = nil)
    @game = game
    @user = user
  end

  def refresh_medals(full = false)
    preload_medals
    if @game
      downloads_medals
      ratings_medals
      followers_medals
      chart_medals
      vig_medals
      king_medals
    elsif @user
      age_medals
      level_2_medals
      level_4_medals
      level_6_medals
      level_10_medals
      level_16_medals
      level_26_medals
      followed_games_medals if recently_logged? || full
      rated_games_medals if recently_logged? || full
      downloaded_games_medals if recently_logged? || full
      events_medals if recently_logged? || full
      # life_medals
      games_medals if recently_logged? || full
      game_medals_1
      game_medals_10
      user_games_medals if recently_logged? || full
      # user_downloads_medals
    end
  end

  private

  def recently_logged?
    @recently_logged ||= @user.updated_at > 2.hours.ago
  end

  def preload_medals
    if @game
      @medals = @game.medals.to_a
    elsif @user
      @medals = @user.medals.to_a
    end
  end

  def age_medals
    score = @user.sing_up_age > 0 ? @user.sing_up_age : nil
    score = age[:positions].find { |p| @user.sing_up_age >= p }
    update_medal age, score
  end

  def level_2_medals
    score = @user.level >= 2 ? 1 : nil
    update_medal level_2, score
  end

  def level_4_medals
    score = @user.level >= 4 ? 1 : nil
    update_medal level_4, score
  end

  def level_6_medals
    score = @user.level >= 6 ? 1 : nil
    update_medal level_6, score
  end

  def level_10_medals
    score = @user.level >= 10 ? 1 : nil
    update_medal level_10, score
  end

  def level_16_medals
    score = @user.level >= 16 ? 1 : nil
    update_medal level_16, score
  end

  def level_26_medals
    score = @user.level >= 26 ? 1 : nil
    update_medal level_26, score
  end

  def followed_games_medals
    score = @user.followed_games.count >= 25 ? 1 : nil
    update_medal followed_games, score
  end

  def rated_games_medals
    score = @user.rated_games.count >= 50 ? 1 : nil
    update_medal rated_games, score
  end

  def downloaded_games_medals
    score = @user.downloaded_games.count >= 100 ? 1 : nil
    update_medal downloaded_games, score
  end

  def events_medals
    score = @user.event_subscriptions.count >= 10 ? 1 : nil
    update_medal events, score
  end

  def life_medals
    score = nil
    if @user.commented_games.count >= 50 && @user.followed_games.count >= 50 &&
       @user.rated_games.count >= 100 && @user.downloaded_games.count >= 250

      score = 1
    end
    update_medal life, score
  end

  def games_medals
    score = count_rel(@user, :games) > 0 ? 1 : nil
    update_medal games, score
  end

  def game_medals_1
    score = @user.game_medals.count >= 1 ? 1 : nil
    update_medal game_medals_1, score
  end

  def game_medals_10
    score = @user.game_medals.count >= 10 ? 1 : nil
    update_medal game_medals_10, score
  end

  def user_games_medals
    score = count_rel(@user, :games) > 10 ? 1 : nil
    update_medal user_games, score
  end

  def user_downloads_medals
    score = count_rel(@user, :games) > 1000 ? 1 : nil
    update_medal user_downloads, score
  end

  def downloads_medals
    score = downloads[:positions].find { |p| @game.downloads_count >= p }
    update_medal downloads, score
  end

  def ratings_medals
    score = ratings[:positions].find { |r| @game.ratings_count >= r }
    update_medal ratings, score
  end

  def followers_medals
    score = followers[:positions].find { |r| @game.followings_count >= r }
    update_medal followers, score
  end

  def chart_medals
    score = chart[:positions].find { |p| @game.ratings_chart <= p }
    update_medal chart, score
  end

  def vig_medals
    score = @game.chart_position(:followings_count) <= 15 ? 1 : nil
    update_medal vig, score
  end

  def king_medals
    subset = Game.where(genre_id: @game.genre_id)
    score = @game.chart_position(:ratings_abs, subset) == 1 ? 1 : nil
    update_medal king, score
  end

  def update_medal(type, score)
    medal = medal_for type
    medal.descending = type.descending
    score ? create_medal(medal, score) : destroy_medal(medal)
  end

  def medal_for(type)
    @medals.find { |m| m.key == type.symbol } ||
      @game&.medals&.new(key: type.symbol)    ||
      @user&.medals&.new(key: type.symbol)
  end

  def create_medal(medal, score)
    service = MedalsService.new(score: score)
    service.update(medal)
  rescue MedalsService::UpdateError
    nil
  end

  def destroy_medal(medal)
    service = MedalsService.new({})
    service.destroy(medal)
  rescue MedalsService::DestroyError
    nil
  end

  def count_rel(model, association)
    if model.respond_to?("#{association}_count")
      model.public_send("#{association}_count")
    else
      model.public_send(association).count
    end
  end

  Settings.medals.keys.each do |key|
    define_method(key) do
      Settings.medals[key]
    end
  end
end
