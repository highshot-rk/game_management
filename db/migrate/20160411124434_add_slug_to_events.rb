class AddSlugToEvents < ActiveRecord::Migration
  def up
    add_column :events, :slug, :string
    say_with_time('Generating slugs') { generate_slugs! }
    change_column :events, :slug, :string, null: false
    add_index :events, :slug, unique: true
  end

  def down
    remove_column :events, :slug
  end

  private

  def generate_slugs!
    ActiveRecord::Base.record_timestamps = false
    Event.find_each do |event|
      event.slug = nil
      event.save!
    end
  ensure
    ActiveRecord::Base.record_timestamps = true
  end
end
