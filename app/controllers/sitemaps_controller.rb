class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml do
        render layout: false
      end
      format.html
    end
  end

  def games
    respond_to do |format|
      @sitemap_data = SitemapFragment.where(fragmentable_type: 'Game').order(:id).page(params[:page]).per(500)
      format.xml do
        render layout: false
      end
    end
  end

  def users
    respond_to do |format|
      @sitemap_data = SitemapFragment.where(fragmentable_type: 'User').order(:id).page(params[:page]).per(500)
      format.xml do
        render layout: false
      end
    end
  end

  def events
    respond_to do |format|
      @sitemap_data = SitemapFragment.where(fragmentable_type: 'Event').order(:id).page(params[:page]).per(500)
      format.xml do
        render layout: false
      end
    end
  end

  def pages
    respond_to do |format|
      format.xml do
        render layout: false
      end
    end
  end
end
