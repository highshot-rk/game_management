# frozen_string_literal: true
ActiveAdmin.register Homepage do
  actions :all, except: [:create, :new, :destroy]

  index do
    selectable_column
    column :id
    column :logo_description
    column :logo do |homepage|
      image_tag(homepage.logo.url, style: 'width: 100px')
    end

    actions
  end

  member_action :remove, method: :post do
    resource.update!(logo: nil)
    redirect_to admin_homepages_path, notice: 'Removed!'
  end

  form html: { multipart: true } do |f|
    f.inputs 'Homepage', multipart: true do
      f.input :logo_description, as: :string
      f.input :logo, required: true, as: :file
    end
    f.actions
  end

  action_item :remove, only: :show do
    link_to 'Remove Image', remove_admin_homepage_path(homepage.id), method: :post
  end

  filter :updated_at

  permit_params :logo_description, :logo
end
