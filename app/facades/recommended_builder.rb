# frozen_string_literal: true
class RecommendedBuilder
  attr_reader :current_user

  METHODS_REQUIRING_USER = [:followed_genres_language_games_last_3_months, 
                            :followed_parent_genre_language_games_limit_two,
                            :followed_parent_games, :followed_genres_language_games,
                            :commented_genres_language_games, :downloaded_genres_and_language_games].freeze

  def initialize(base_query, current_user)
    @base_query = base_query
    @current_user = current_user
  end

  def build(max_elements)
    games = Set.new
    if current_user
      METHODS_REQUIRING_USER.each do |method|
        begin
          games += send(method).pluck(:id) if games.count < max_elements
        rescue StandardError => e
          Rails.logger.error("ERROR in #{method}")
          Raven.capture_exception(e) if defined?(Raven)
          raise e if Rails.env.development?
        end
      end
    end
    games += best_games_same_language_12_months_ago.pluck(:id)  if games.count < max_elements
    games += best_games_same_language.pluck(:id)  if games.count < max_elements
    games += best_english_games.pluck(:id)        if games.count < max_elements
    games.first(max_elements)
  end

  protected

  # 0. Popular Games with the same genre and languages of the followed games, order by random in the last 3 months
  # excluding games already downloaded, followed, commented, rated and your games; limit 3
  # @return [ActiveRecord::Relation]
  def followed_genres_language_games_last_3_months
    Game.joins(:genre).joins(:languages)
        .where_subquery('genres.id IN (?)', current_user.followed_games.select(:genre_id))
        .where_subquery('languages.id IN (?)', current_user.followed_games.joins(:languages).select('languages.id'))
        .where('games.created_at > ? AND games.created_at < ?', 10.months.ago, 1.months.ago)
        .popular
        .order_by_indiepad.random_order
        .where.not(id: excluded_games_ids)
        .limit(3)
  end

  # 1. Games uploaded by an user whose game has been followed, commented and downloaded by the current user, with the same genre and languages of the followed games
  # excluding games already downloaded, followed, commented, rated and your games;
  # @return [ActiveRecord::Relation]
  def followed_parent_genre_language_games_limit_two
    Game.joins(:genre).joins(:languages)
        .where(user_id: interesting_authors_ids.sample(10))
        .where_subquery('genres.id IN (?)', current_user.followed_games.select(:genre_id))
        .where_subquery('languages.id IN (?)', current_user.followed_games.joins(:languages).select('languages.id'))
        .order_by_indiepad.random_order
        .where.not(id: excluded_games_ids)
  end

  # 2. Games uploaded by an user whose game has been followed, commented and downloaded by the current user,
  # excluding games already downloaded, followed, commented, rated and your games;
  # @return [ActiveRecord::Relation]
  def followed_parent_games
    Game.where(user_id: interesting_authors_ids.sample(10))
        .order_by_indiepad.random_order
        .where.not(id: excluded_games_ids)
  end

  # 3. Games with the same genre and languages of the followed games
  # excluding games already downloaded, followed, commented, rated and your games;
  # @return [ActiveRecord::Relation]
  def followed_genres_language_games
    Game.joins(:genre).joins(:languages)
        .where_subquery('genres.id IN (?)', current_user.followed_games.select(:genre_id))
        .where_subquery('languages.id IN (?)', current_user.followed_games.joins(:languages).select('languages.id'))
        .popular
        .order_by_indiepad.random_order
        .where.not(id: excluded_games_ids)
    # followed_genres = current_user.followed.collect(&:genre_id).uniq
    # games = Game.where { |game| followed_genres.include?(game.genre_id) }
    # games - current_user.downloaded_games
  end

  # 4. Games with the same genre and languages of the commented games
  # excluding games already downloaded, followed, commented, rated and your games;
  # @return [ActiveRecord::Relation]
  def commented_genres_language_games
    Game.joins(:genre).joins(:languages)
        .where_subquery('genres.id IN (?)', current_user.commented_games.select(:genre_id))
        .where_subquery('languages.id IN (?)', current_user.commented_games.joins(:languages).select('languages.id'))
        .popular
        .order_by_indiepad.random_order
        .where.not(id: excluded_games_ids)
  end

  # 4. Games with the same genre and languages of the commented games
  # even if already downloaded, followed, commented, rated and your games;
  # @return [ActiveRecord::Relation]
  def downloaded_genres_and_language_games
    Game.joins(:genre).joins(:languages)
        .where_subquery('genres.id IN (?)', current_user.downloaded_games.select(:genre_id))
        .where_subquery('languages.id IN (?)', current_user.downloaded_games.joins(:languages).select('languages.id'))
        .popular
        .order_by_indiepad.random_order
  end

  # Best rated games having the user's language not already downloaded updated or created 6 months ago
  # @return [ActiveRecord::Relation]
  def best_games_same_language_12_months_ago
    return Game.none unless user_language
    games = user_language.games.where('games.created_at > ? AND games.created_at < ?', 10.months.ago, 1.months.ago).order(ratings_abs: :desc)
    games = games.where.not(id: excluded_games_ids) if current_user
    games
  end

  # Best rated games having the user's language not already downloaded
  # @return [ActiveRecord::Relation]
  def best_games_same_language
    return Game.none unless user_language
    games = user_language.games.order(ratings_abs: :desc)
    games = games.where.not(id: excluded_games_ids) if current_user
    games
  end

  # Most downloaded english games not already downloaded
  # @return [ActiveRecord::Relation]
  def best_english_games
    return Game.none unless default_language
    games = default_language.games.order(downloads_count: :desc)
    games = games.where.not(id: excluded_games_ids) if current_user
    games
  end

  # Restituisce la lingua utente
  # @return [Language]
  def user_language
    @user_language ||= Language.find_by(locale: I18n.locale)
  end

  def default_language
    @default_language ||= Language.default
  end

  def excluded_games_ids
    @excluded_games_ids ||= downloaded_games_ids + followed_games_ids + 
                            commented_games_ids + user_games_ids
  end

  def user_games_ids
    @user_games_ids ||= current_user.games.pluck(:id)
  end

  def commented_games_ids
    @commented_games_ids ||= current_user.commented_games.pluck(:id)
  end

  def followed_games_ids
    @followed_games_ids ||= current_user.followed_games.pluck(:id)
  end

  def downloaded_games_ids
    @dowloaded_games_ids ||= current_user.downloaded_games.pluck(:id)
  end

  def interesting_authors_ids
    @interesting_authors_ids ||= (authors_followed_games_ids + authors_commented_games_ids + authors_rated_games_ids).uniq
  end

  def authors_followed_games_ids
    @authors_followed_games_ids ||= current_user.followed_games.pluck(:user_id)
  end

  def authors_commented_games_ids
    @authors_commented_games_ids ||= current_user.commented_games.pluck(:user_id)
  end

  def authors_rated_games_ids
    @authors_rated_games_ids ||= current_user.rated_games.pluck(:user_id)
  end
end
