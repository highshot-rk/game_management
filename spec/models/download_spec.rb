# frozen_string_literal: true
# == Schema Information
#
# Table name: downloads
#
#  id               :integer          not null, primary key
#  download_link_id :integer          not null
#  user_id          :integer
#  count            :integer          default(1), not null
#  created_at       :datetime         not null
#  ip               :string
#
# Indexes
#
#  index_downloads_on_download_link_id_and_user_id  (download_link_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0cd58e10e1  (user_id => users.id)
#  fk_rails_107728e285  (download_link_id => download_links.id)
#

require 'rails_helper'

describe Download, type: :model do
  it 'validates unique ips when there are 3 hits in the same day' do
    create_list(:download, 3, user: nil, ip: '127.0.0.1')
    subject.ip = '127.0.0.1'
    expect(subject).to have(1).error_on(:ip)
    subject.user = User.new
    expect(subject).to have(0).error_on(:ip)
    subject.ip = ''
    subject.user = nil
    Download.update_all(ip: nil)
    expect(subject).to have(0).error_on(:ip)
  end

  context 'on save', transactions: true do
    let(:game) { create(:game, :with_downloads) }

    it 'creates or updates stats' do
      expect do
        game.download_links.first.downloads.create!
      end.to change(Stat, :count).by(1)
      expect do
        game.download_links.first.downloads.create!
      end.not_to change(Stat, :count)
      expect(Stat.last.downloads).to eq(2)
      expect(Stat.last.created_at).to eq(Date.current)
    end

    it 'creates or updates stats concurrently' do
      expect do
        game.download_links.first.downloads.create!
      end.to change(Stat, :count).by(1)
      expect_any_instance_of(ActiveRecord::Relation).to receive(:pluck).with(:id).and_call_original
      allow_any_instance_of(ActiveRecord::Relation).to receive(:first_or_create!, &:create!)
      expect do
        game.download_links.first.downloads.create!
      end.not_to change(Stat, :count)
      expect(Stat.last.downloads).to eq(2)
      expect(Stat.last.created_at).to eq(Date.current)
    end

    it 'updates games\' download_count' do
      expect(game.downloads_count).to eq(0)
      game.download_links.first.downloads.create!
      expect(game.reload.downloads_count).to eq(1)
    end
  end
end
