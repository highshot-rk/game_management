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

require 'rails_helper'

RSpec.describe Slideshow, type: :model do
  it 'shows the original file when it\'s still processing' do
    slideshow = create(:slideshow, image_processing: true)
    slideshow.image_processing = true
    expect(slideshow.image.url(:normal)).to include('/original/')
    slideshow.image_processing = false
    expect(slideshow.image.url(:normal)).to include('/normal/')
  end
end
