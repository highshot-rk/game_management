# frozen_string_literal: true
class GamesSectionsController < ApplicationController
  before_action :setup_menu_bar
  before_action :setup_sections, only: :index
  before_action :setup_params!, only: [:news, :downloaded, :popular, :chart]

  respond_to :html

  def news
    @filter = whitelist_params([:popular, :latest, :last_commented, :last_updated])
    @games = load_games(params[:genre].present? ? genre.games : Game)
             .send(@filter).decorate
    @last_6_updated = load_games(params[:genre].present? ? genre.games : Game)
             .limit(6)
             .last_updated.decorate
  end

  def downloaded
    @available_filters = [:today, :last_week, :last_month, :everytime]
    @filter = whitelist_params(@available_filters)
    @games = load_games(Game.send("downloaded_#{@filter}")).decorate
  end

  # def popular
  #   @games = load_games(params[:platform].present? ? platform.games : Game)
  #            .popular.decorate
  # end

  def chart
    @available_filters = [:voted, :followed, :most_downloaded]
    @filter = whitelist_params(@available_filters)
    @games = load_games(params[:genre].present? ? genre.games : Game)
             .send(@filter).decorate
  end

  private

  def setup_params!
    @params = params.to_h.symbolize_keys.except(:controller, :action, :locale)
  end

  def whitelist_params(params_list)
    if params_list.is_a? Hash
      filter = whitelist_array_parameters(params_list.keys)
      params_list[filter]
    else
      whitelist_array_parameters(params_list)
    end
  end

  def whitelist_array_parameters(params_list)
    params_list.include?(filter) ? filter : params_list.first
  end

  def landing_games
    Game
      .includes(:screen, :online_links, :max_score)
      .limit(6)
  end

  def load_games(root = Game)
    (!current_user || !current_user.setting.present? || (current_user.setting.present? && !current_user.setting.adult_content)) ? root.not_adults.includes(:screen, :online_links, :max_score).page(params[:page]) : root.includes(:screen, :online_links, :max_score).page(params[:page])
  end

  def platform
    @platform ||= Platform.find(params[:platform])
  end

  def genre
    @genre ||= Genre.find(params[:genre])
  end

  def filter
    params[:filter].to_s.to_sym
  end

  def setup_menu_bar
    @menu_bar = %w(news downloaded popular chart)
  end

  def setup_sections
    @section = params[:action]
  end
end
