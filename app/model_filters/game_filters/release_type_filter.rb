module GameFilters
  class ReleaseTypeFilter < ::ModelFilter
    def apply_filter(model)
      if param.is_a? Array
        model.where('release_type IN (?)', cleaned_params)
      elsif model.model.release_types.include?(param.to_s)
        model.public_send(param.to_s)
      else
        model
      end
    end

    private

    def cleaned_params
      param.select { |e| e.to_s =~ /\A[0-9]+\Z/ }
    end
  end
end
