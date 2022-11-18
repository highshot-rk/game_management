class AddPlayOnlineNameToDownloadLinks < ActiveRecord::Migration
  def change
    add_column :download_links, :play_online_name, :string
  end
end
