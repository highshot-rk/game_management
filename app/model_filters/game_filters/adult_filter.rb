module GameFilters
  class AdultFilter < ::ModelFilter
    def apply_filter(model)
      if param.present?
        model.joins(:download_links)
             .where(adult_content: true).uniq
      else
        model
      end
    end
  end
end
