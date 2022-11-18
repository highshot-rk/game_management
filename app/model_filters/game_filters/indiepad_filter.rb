# frozen_string_literal: true
module GameFilters
  class IndiepadFilter < ::ModelFilter
    def apply_filter(model)
      if param.present?
        model.joins(:download_links)
             .where(download_links: { play_online_name: 'index.html' })
             .where(indiepad: true).uniq
      else
        model
      end
    end
  end
end
