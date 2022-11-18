class DirectRelationFilter < ModelFilter
  def apply_filter(model)
    model.where("#{filter_name}_id" => param)
  end
end
