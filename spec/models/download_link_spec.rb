# frozen_string_literal: true
# == Schema Information
#
# Table name: download_links
#
#  id                :integer          not null, primary key
#  url               :string
#  broken            :boolean          default(FALSE), not null
#  play_online       :boolean          default(FALSE), not null
#  downloads_count   :integer          default(0), not null
#  game_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  play_online_name  :string
#
# Indexes
#
#  index_download_links_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_9240b3e259  (game_id => games.id)
#

require 'rails_helper'

describe DownloadLink, type: :model do
  it 'can\'t have an url in exclude list' do
    expect(subject).to have(0).errors_on(:url)
    subject.url = 'http://www.indiedb.com/games/whos-your-daddy'
    expect(subject).to have(1).errors_on(:url)
    subject.url = 'https://kitfoxgames.itch.io/moon-hunters'
    expect(subject).to have(1).errors_on(:url)
    subject.url = 'http://gamejolt.com/games/legend-of-hand-official-demo/133891'
    expect(subject).to have(1).errors_on(:url)
    subject.url = 'http://store.steampowered.com/app/421120/'
    expect(subject).to have(1).errors_on(:url)
    subject.url = 'http://google.it'
    expect(subject).to have(0).errors_on(:url)
  end

  it 'can\'t have an url in exclude list (without http)' do
    subject.url = 'kitfoxgames.itch.io/moon-hunters'
    expect(subject).to have(1).errors_on(:url)
  end

  context 'on save' do
    let(:download_link) { create(:download_file) }

    it 'updates games\' download_count', transactions: true do
      download_link
      expect(Sidekiq::Worker).to have_enqueued_sidekiq_job([download_link.id])
    end
  end
end
