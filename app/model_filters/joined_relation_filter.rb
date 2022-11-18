class JoinedRelationFilter < ModelFilter
  def apply_filter(model)
    model.joins(model_name)
         .where(model_name => { id: param }).distinct
  end

  private

  def model_name
    filter_name.to_s.pluralize.to_sym
  end
end
