class AddLogoDescriptionToHomepage < ActiveRecord::Migration[5.0]
  def change
    add_column :homepages, :logo_description, :string
  end
end
