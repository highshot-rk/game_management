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

require 'rails_helper'

RSpec.describe Homepage, type: :model do
  it 'shows the original file when it\'s still processing' do
    homepage = create(:homepage, logo_processing: true)
    homepage.logo_processing = true
    expect(homepage.logo.url(:normal)).to include('/original/')
    homepage.logo_processing = false
    expect(homepage.logo.url(:normal)).to include('/normal/')
  end
end
