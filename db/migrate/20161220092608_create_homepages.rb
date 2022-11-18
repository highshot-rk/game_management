# frozen_string_literal: true
class CreateHomepages < ActiveRecord::Migration
  def change
    create_table :homepages do |t|
      t.boolean :logo_processing
      t.timestamps null: false
    end
    add_attachment :homepages, :logo
  end
end
