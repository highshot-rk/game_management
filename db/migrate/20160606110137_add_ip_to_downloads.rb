class AddIpToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :ip, :string
  end
end
