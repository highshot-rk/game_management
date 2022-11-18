# frozen_string_literal: true
ActiveAdmin.register Slideshow do
  actions :all, except: [:create, :new, :destroy]

  index do
    selectable_column
    [:id, :url].each { |c| column c }
    column :image do |slideshow|
      image_tag(slideshow.image.url, style: 'width: 100px')
    end

    actions
  end

  form html: { multipart: true } do |f|
    f.inputs 'Slideshow', multipart: true do
      f.input :url, as: :string
      f.input :image, required: true, as: :file
    end
    f.actions
  end

  filter :url
  filter :updated_at

  permit_params :url, :image
end
