class EnableExtensionUnaccent < ActiveRecord::Migration
  def change
    enable_extension 'unaccent'
  end
end
