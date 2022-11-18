# frozen_string_literal: true
ActiveAdmin.register Following do
  actions :all, except: [:create, :edit, :update, :destroy]

  [:id, :user, :game].each { |f| filter f }

  index do
    selectable_column
    [:id, :user, :game, :created_at].each { |c| column c }
    actions
  end
end
