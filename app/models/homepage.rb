# frozen_string_literal: true

# == Schema Information
#
# Table name: homepages
#
#  id                :integer          not null, primary key
#  logo_processing   :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  logo_description  :string
#

class Homepage < ApplicationRecord
  has_attached_file :logo, styles: { normal: '1x1<' },
                           processors: %i[thumbnail paperclip_optimizer]

  validates_attachment :logo,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 4.megabytes }

  process_in_background :logo, processing_image_url: :processing_image_fallback

  def processing_image_fallback
    options = logo.options
    options[:interpolator].interpolate(options[:url], logo, :original)
  end
end
