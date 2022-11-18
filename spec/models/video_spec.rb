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

require 'rails_helper'

RSpec.describe Video, type: :model do
  it 'has always an url or a file' do
    expect(subject).to have(1).error_on(:base)
    subject.url = ''
    expect(subject).to have(1).error_on(:base)
    subject.url = 'something'
    expect(subject).to have(0).error_on(:base)
    subject.url = nil
    subject.file_file_name = 'something'
    expect(subject).to have(0).error_on(:base)
  end
end
