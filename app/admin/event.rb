# frozen_string_literal: true
ActiveAdmin.register Event do
  actions :all, except: [:new, :create, :edit, :update]

  [:title, :event_type, :start, :end].each { |f| filter f }

  scope :all
  scope :running
  scope :ended

  index do
    selectable_column
    [:id, :title, :event_type, :start, :end, :created_at, :user, :website, :rules, :prizes].each { |c| column c }
    actions
  end
end
