# frozen_string_literal: true
ActiveAdmin.register Comment do
  actions :all, except: [:create, :new]

  includes :parent
  [:id, :text, :user, :game].each { |f| filter f }

  index do
    selectable_column
    [:id, :text, :user, :game, :parent].each { |c| column c }
    actions
  end

  permit_params :text, :game_id, :parent_id, :user_id
end
