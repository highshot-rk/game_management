# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[arcade subscriptions your_games history]
  respond_to :html

  def landing
    load_last_updated_followed_games
    query_of_the_day
    @recommended = RecommendedBuilder.new(Game, current_user).build(9)
    @downloaded = landing_games.downloaded_today.pluck(:id)
    @recent = landing_games.latest.pluck(:id)

    query_batch = QueryBatch.new do |ids|
      if !current_user || current_user.setting.blank? || (current_user.setting.present? && !current_user.setting.adult_content)
        Game.where(id: ids).where(adult_content: false).includes(:screen, :online_links, :max_score).decorate.map { |g| [g.id, g] }.to_h
      else
        Game.where(id: ids).includes(:screen, :online_links, :max_score).decorate.map { |g| [g.id, g] }.to_h
      end
    end

    @cache_key = query_batch.cache_key
    @recommended = query_batch.load(@recommended)
    @downloaded = query_batch.load(@downloaded)
    @recent = query_batch.load(@recent)
  end

  def indiepad
    @games = Game.indiepad.limit(45).decorate
    render layout: 'console'
  end

  def arcade
    @games = current_user.followed_games.online_and_mobile.decorate
    render layout: 'console'
  end

  def followed_games
    @games = current_user.followed_games
                         .where('games.news_count > 0')
                         .includes(:screen, :online_links)
                         .limit(12)
                         .order('games.last_news_at DESC NULLS LAST').decorate
  end

  def subscriptions
    @games = if current_user.followed_games.present?
               followed_games
             else
               Game.last_updated.limit(6).decorate
             end
  end

  def your_games
    @games = current_user.games.includes(:screen, :online_links)
             .page(params[:page]).decorate
  end

  def history
    @downloaded_games = current_user
             .downloaded_games
             .includes(:screen, :online_links)
             .order_by_download_date
             .limit(3).decorate
    @played_score_games = current_user
             .played_score_games
             .includes(:screen, :online_links)
             .order(created_at: :desc)
             .limit(3).decorate
    @commented_games = current_user
             .commented_games
             .includes(:screen, :online_links)
             .order(created_at: :desc)
             .limit(3).decorate
    @followed_games = current_user
             .followed_games
             .includes(:screen, :online_links)
             .order('followings.created_at DESC')
             .limit(3).decorate
    @rated_games = current_user
             .rated_games
             .includes(:screen, :online_links)
             .order('ratings.created_at DESC')
             .limit(3).decorate
  end

  def recommended
    ids = RecommendedBuilder.new(Game, current_user).build(12)
    @games = if ids.any?
               landing_games(12).with_ids_keeping_order(ids).preload(:screen, :online_links, :max_score).decorate
             else
               Game.none
             end
    # @games = ids.any? ? landing_games(12).with_ids_keeping_order(ids).decorate : Game.none
  end

  private

  def load_last_updated_followed_games
    return unless current_user
    @last_updated_followed_games = current_user
                                   .followed_games.updated_since(30).includes(:screen, :online_links).limit(6)
                                   .order('games.last_news_at DESC NULLS LAST').decorate
  end

  def query_of_the_day
    day_of_the_week   = Time.now.wday
    games = Game.includes(:screen, :online_links).limit(3)
    games = case day_of_the_week
              when 0 then games.over_1000_downloads
              when 1 then games.never_commented
              when 2 then games.anniversary
              when 3 then games.followed
              when 4 then games.indiepad
              when 5 then games.having_scores
              else games.last_updated
            end
    @query_of_the_day = games.decorate
  end

  def landing_games(limit = 6)
    (!current_user || !current_user.setting.present? || (current_user.setting.present? && !current_user.setting.adult_content)) ? Game.where(adult_content: false).limit(limit) : Game.limit(limit)
  end

  def setup_sections
    @section = params[:action]
  end
end
