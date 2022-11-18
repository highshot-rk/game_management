# frozen_string_literal: true
ActiveAdmin.register User do
  actions :all, except: [:new, :create, :destroy]
  permit_params :username, :email, :score, :confirmed_at, :verified,
                :banned_at, :first_name, :surname, :phone_number

  [:username, :email, :staff, :verified, :banned_at, :created_at, :updated_at, :score, :confirmed_at].each { |f| filter f }

  index do
    selectable_column
    [:id, :username, :email, :staff, :verified, :banned_at, :created_at, :updated_at, :score, :confirmed_at].each { |c| column c }
    actions
  end
end
