module GameFilters
  class MobileFilter < ::ModelFilter
    def apply_filter(model)
      if param.present?
        model.joins(:download_links)
             .where(mobile_first: true).uniq
      else
        model
      end
    end
  end
end
