class AddSlugToPlatforms < ActiveRecord::Migration
  def up
    add_column :platforms, :slug, :string
    say_with_time 'Generating slug' do
      Platform.find_each do |platform|
        platform.slug = nil
        platform.save!
      end
    end
    change_column :platforms, :slug, :string, null: false
    add_index :platforms, :slug, unique: true
  end

  def down
    remove_column :platforms, :slug
  end
end
