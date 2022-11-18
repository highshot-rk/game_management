# frozen_string_literal: true

ActiveAdmin.register Score do
  actions :all, except: %i[edit update destroy]
  includes :user, :game

  filter :user_username_cont, label: 'User name contains'
  filter :game_title_cont, label: 'Game Title contains'
  
  [:name, :value, :created_at, :updated_at].each { |f| filter f }

  index do
    selectable_column
    [:id, :name, :user, :game, :value, :created_at, :updated_at].each { |c| column c }
    actions
  end
end
