# frozen_string_literal: true
class LevelsController < ApplicationController
  before_action :authenticate_user!

  def index
    MedalsManager.new(nil, current_user).refresh_medals
    render layout: nil
  end
end
