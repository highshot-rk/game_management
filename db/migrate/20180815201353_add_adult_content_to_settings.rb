class AddAdultContentToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :adult_content, :boolean, default: false
  end
end
