# frozen_string_literal: true
class SearchController < ApplicationController
  before_action :fix_old_links!
  before_action :set_search_params!

  def games
    @games =
      if @query.present?
        apply_filters(Game.includes(:screen, :online_links).where(id: Game.search_all(@query)))
      elsif search_params.keys.any?
        apply_filters(Game.includes(:screen, :online_links))
      else
        Game.none.page(1)
      end
  end

  private

  def fix_old_links!
    return unless params[:format] == 'php'
    redirect_to(
      search_path(search: { q: params[:name], author: params[:auth] }),
      status: :moved_permanently)
  end

  def apply_filters(base_query)
    base_query.filter(mapped_search_params)
              .page(params[:page]).decorate
  end

  def mapped_search_params
    remap_search_keys! search_params
    # @search_params = params.permit(
    #   search: [:language, :author, :genre, :platform, :tool, :release_type])[:search] || {}
  end

  def remap_search_keys!(params)
    Settings.search.mappings.to_h.each do |k, v|
      params[v] = params.delete(k) if params[k]
    end
    params
  end

  def set_search_params!
    @query = search_object[:q]
    @search_params = search_params
  end

  def search_object
    @search_object ||= begin
      search = params.fetch(:search, {})
      search.respond_to?(:merge) ? search : {}
    end
  end

  def search_params
    params.permit(:ip, :po, :sc, :mo, :ad, l: [], g: [], y: [], p: [], t: [], rt: []).merge(search_object.permit(:author))
  end
end
