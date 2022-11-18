# frozen_string_literal: true
module SitemapRefresh
  extend ActiveSupport::Concern

  included do
    after_save :rebuild_sitemap_fragment!
    has_one :fragment, as: :fragmentable, class_name: 'SitemapFragment', dependent: :destroy
  end

  def rebuild_sitemap_fragment!
    SitemapFragment.update_by_model(decorate)
  end
end
