class SessionsController < Devise::SessionsController
  before_action :set_from_parameter!, only: :new

  def create
    super
  end

  def set_from_parameter!
    @from = params[:from]
  end
end
