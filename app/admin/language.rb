# frozen_string_literal: true
ActiveAdmin.register Language do
  actions :all, except: :destroy

  permit_params :name, :locale
end
