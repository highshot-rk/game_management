# frozen_string_literal: true

# == Schema Information
#
# Table name: slideshows
#
#  id                 :integer          not null, primary key
#  url                :text             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_processing   :boolean
#

class Slideshow < ApplicationRecord
  has_attached_file :image, styles: { normal: '1x1<' },
                            processors: %i[thumbnail paperclip_optimizer]

  validates_attachment :image,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 4.megabytes }

  process_in_background :image, processing_image_url: :processing_image_fallback

  validates :url, presence: true

  def processing_image_fallback
    options = image.options
    options[:interpolator].interpolate(options[:url], image, :original)
  end
end
