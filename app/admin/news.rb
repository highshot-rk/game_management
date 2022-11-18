# frozen_string_literal: true
ActiveAdmin.register News do
  actions :all, except: [:new, :create, :edit, :update, :destroy]

  [:id, :text, :user, :game].each { |f| filter f }

  index do
    selectable_column
    [:id, :text, :game].each { |c| column c }
    actions
  end
end
