# frozen_string_literal: true
ActiveAdmin.register Tool do
  actions :all, except: :destroy

  permit_params :name
end
