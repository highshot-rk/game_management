# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id                :integer          not null, primary key
#  type              :string           not null
#  url               :text
#  game_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_processing   :boolean
#
# Indexes
#
#  index_resources_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_a9b6901174  (game_id => games.id)
#

class Resource < ApplicationRecord
  belongs_to :game

  validates :game, presence: true

  has_attached_file :file, styles: { large: ['800x800^', :png], medium: '320x560>' },
                           processors: %i[thumbnail paperclip_optimizer]

  validates_attachment :file,
                       content_type: {
                         content_type: ['image/jpeg', 'image/gif', 'image/png']
                       },
                       size: { less_than: 4.megabytes }

  process_in_background :file, processing_image_url: :processing_image_fallback

  def processing_image_fallback
    options = file.options
    options[:interpolator].interpolate(options[:url], file, :original)
  end

  include UrlOrFile
end
