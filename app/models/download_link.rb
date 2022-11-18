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

class DownloadLink < ApplicationRecord
  include AfterCommitAction

  belongs_to :game
  has_many :platform_links, dependent: :delete_all
  has_many :platforms, through: :platform_links
  has_many :downloads, dependent: :delete_all
  has_many :reports, dependent: :delete_all

  has_attached_file :file
  validates_attachment :file,
                       size: { less_than: 750.megabytes },
                       content_type: { content_type: /\A.*\Z/ }

  include UrlOrFile

  validates :url, domain: { exclude: Settings.download_links.exclusions }, uniqueness: true, allow_nil: true

  after_create :check_and_prepare_html5

  def check_and_prepare_html5
    execute_after_commit do
      Html5GamePrepare.perform_later(id) if file_file_name && html5_candidate?
    end
  end

  def html5_candidate?
    true
  end

  def local?
    !(!file)
  end
end
