# frozen_string_literal: true
ActiveAdmin.register Platform do
  actions :all, except: :destroy

  permit_params :name
end
