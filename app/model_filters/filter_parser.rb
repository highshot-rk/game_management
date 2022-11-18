class FilterParser
  def initialize(model, params)
    @model = model.all
    @params = params
  end

  def filter
    filter_from_params
      .each do |filter_model|
        @model = filter_model.try(:apply_on, @model) || @model
      end
    @model
  end

  private

  def filter_from_params
    model_name = @model.name
    @filters = clean_params.map do |key, value|
      begin
        "#{model_name}Filters::#{key.to_s.classify}Filter"
          .constantize.new(key, value)
      rescue NameError
        nil
      end
    end
  end

  def clean_params
    @params.to_h.delete_if { |_, v| v.blank? }
  end
end
