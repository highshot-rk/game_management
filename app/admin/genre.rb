# frozen_string_literal: true
ActiveAdmin.register Genre do
  actions :all, except: :destroy

  permit_params :name
end
