class ModelFilter
  attr_reader :filter_name, :param

  def initialize(filter_name, param)
    @filter_name = filter_name
    @param = param
  end

  def apply_on(model)
    apply_filter model.is_a?(Class) ? model.all : model
  end

  protected

  def apply_filter(_model)
    fail NotImplementedError
  end
end
