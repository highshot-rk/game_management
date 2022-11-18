# frozen_string_literal: true
class LanguagesController < ApplicationController
  def edit
    @language = Language.find_by(locale: I18n.locale)
    session[:return_to] ||= request.referer
    render layout: false
  end

  def update
    @language = Language.find(update_params[:id])
    if user_signed_in?
      setting = current_user.setting || current_user.build_setting
      setting.language = @language.id
      setting.save
      redirect_to session.delete(:return_to)
    else
      redirect_to root_path(locale: @language.locale)
    end
  end

  private

  def update_params
    params.require(:language).permit(:id)
  end
end
