# frozen_string_literal: true
ActiveAdmin.register Game do
  actions :all, except: [:new, :create, :edit, :update, :destroy]

  [:id, :title, :user, :release_type, :genre, :tool, :slug].each { |f| filter f }

  scope :all
  scope :popular

  member_action :enable_api, method: :put do
    resource.update!(token: SecureRandom.urlsafe_base64(6))
    redirect_to admin_games_path, notice: 'Records API Enabled'
  end

  action_item :enable_api, only: :show do
    link_to 'Enable Records API', enable_api_admin_game_path(game.id), method: :put unless game.token?
  end

  # Monetisation actions
  action_item :enable, only: :show do
    if game.monetisation.present?
      link_to "Enable Monetisation", enable_admin_game_path(game.monetisation), method: :put if !game.monetisation.approved
    end
  end

  action_item :disable, only: :show do
    if game.monetisation.present?
      link_to "Disable Monetisation", disable_admin_game_path(game.monetisation), method: :put if game.monetisation.approved
    end
  end

  member_action :enable, method: :put do
    monetisation = Monetisation.find(params[:id])
    monetisation.update(approved: true)
    redirect_to admin_games_path
  end

  member_action :disable, method: :put do
    monetisation = Monetisation.find(params[:id])
    monetisation.update(approved: false)
    redirect_to admin_games_path
  end

  index do
    selectable_column
    [:id, :slug, :title, :user, :author, :downloads_count, :release_type, :tool, :genre].each { |c| column c }
    actions
  end
end
