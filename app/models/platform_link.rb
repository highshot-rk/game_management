# frozen_string_literal: true

# == Schema Information
#
# Table name: platform_links
#
#  id               :integer          not null, primary key
#  download_link_id :integer          not null
#  platform_id      :integer          not null
#
# Indexes
#
#  index_platform_links_on_download_link_id                  (download_link_id)
#  index_platform_links_on_download_link_id_and_platform_id  (download_link_id,platform_id) UNIQUE
#  index_platform_links_on_platform_id                       (platform_id)
#
# Foreign Keys
#
#  fk_rails_56d9fe46e4  (download_link_id => download_links.id)
#  fk_rails_cc6af6cc68  (platform_id => platforms.id)
#

class PlatformLink < ApplicationRecord
  belongs_to :platform
  belongs_to :download_link

  validates :platform, presence: true
  validates :download_link, presence: true

  validates :platform_id, uniqueness: { scope: :download_link_id }
end
