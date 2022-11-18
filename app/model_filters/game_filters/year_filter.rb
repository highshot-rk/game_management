module GameFilters
  class YearFilter < ::ModelFilter
    def apply_filter(model)
      if param.is_a? Array
        model.where('extract(year from games.created_at) IN (?)', cleaned_params)
      elsif model.model.year.include?(param.to_s)
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