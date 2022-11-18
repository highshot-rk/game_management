module GameFilters
  class PlatformFilter < ::ModelFilter
    def apply_filter(model)
      model.joins(:platforms)
           .where(platforms: { id: param }).distinct
    end
  end
end
