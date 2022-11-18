module GameFilters
  class AuthorFilter < ::ModelFilter
    def apply_filter(model)
      model.where(author: param)
    end
  end
end
