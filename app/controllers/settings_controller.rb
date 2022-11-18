# frozen_string_literal: true
class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_user!

  def edit
    @user = current_user
    @setting = current_user.current_settings
  end

  def update
    @setting = current_user.current_settings
    unless @setting.update(Setting::DEFAULT_VALUES.merge(update_params))
      flash[:error] = @setting.errors.full_message.to_sentence
    end
    redirect_to root_url
  end

  private

  def assign_user!
    @user = current_user
  end

  def update_params
    params.require(:setting).permit(*Setting::DEFAULT_VALUES.keys, :language, :notification_sound, :adult_content)
  end
end
