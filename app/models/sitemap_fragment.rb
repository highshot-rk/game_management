# frozen_string_literal: true

# == Schema Information
#
# Table name: sitemap_fragments
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  fragmentable_id   :integer          not null
#  fragmentable_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  sitemap_fragmentable  (fragmentable_id,fragmentable_type) UNIQUE
#

class SitemapFragment < ApplicationRecord
  belongs_to :fragmentable, polymorphic: true
  validates :content, :fragmentable, presence: true

  class <<self
    def update_by_model(model)
      partial = model.to_partial_path.split('/').last
      rendered = render_view(partial, partial.to_sym => model)
      find_or_initialize_by(fragmentable: model).update(content: rendered)
    end

    private

    def render_view(partial, locals = {})
      view = ActionView::Base.new(ActionController::Base.view_paths, {}, nil, [:xml])
      view.view_paths = 'app/views/sitemaps'
      view.class_eval do
        include Rails.application.routes.url_helpers

        def default_url_options
          options = {
            host: ENV['SITE_URL'] || 'www.indiexpo.net'
          }
          Rails.env.production? ? options.merge!(protocol: 'https') : options
        end
      end
      view.config = Rails.application.config.clone
      view.render(partial: partial, locals: locals)
    end
  end
end
