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

class Download < ApplicationRecord
  belongs_to :download_link
  counter_culture :download_link

  has_one :game, through: :download_link
  counter_culture :game

  belongs_to :user

  after_commit on: :create do
    update_stats
  end

  validate :unique_ip_for_no_user!

  def unique_ip_for_no_user!
    return if !user.nil? || ip.blank?
    errors.add(:ip, :too_many) if too_many_similar?
  end

  def too_many_similar?
    Download.where(ip: ip).where('downloads.created_at > ?', 10.days.ago).count >= Settings.downloads.max_per_ip
  end

  def update_stats
    Stat.create_or_increment! game.id, downloads: count
  end
end
