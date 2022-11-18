class AddLanguageToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :language, :integer
  end
end
