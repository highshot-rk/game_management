class AddDescendantAndStoryToMedals < ActiveRecord::Migration
  def change
    add_column :medals, :descending, :boolean, null: false, default: false
    add_column :medals, :story, :text, array: true, null: false, default: []
  end
end
