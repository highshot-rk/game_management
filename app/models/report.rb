# frozen_string_literal: true

# == Schema Information
#
# Table name: reports
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  download_link_id :integer          not null
#  reason           :integer          default("broken"), not null
#  message          :text
#  resolved         :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_reports_on_download_link_id  (download_link_id)
#  index_reports_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_c7699d537d  (user_id => users.id)
#  fk_rails_fbdb3c71d5  (download_link_id => download_links.id)
#

# i18n-tasks-use t('helpers.label.report.broken')
# i18n-tasks-use t('helpers.label.report.copyright')
# i18n-tasks-use t('helpers.label.report.offensive')
# i18n-tasks-use t('helpers.label.report.sexual')
# i18n-tasks-use t('helpers.label.report.spam')
# i18n-tasks-use t('helpers.label.report.violent')
class Report < ApplicationRecord
  enum reason: %i[broken spam sexual violent offensive copyright]

  belongs_to :user
  belongs_to :download_link
  has_one :game, through: :download_link

  validates :user, :download_link, presence: true

  scope :todo, -> { where(resolved: false) }
  scope :resolved, -> { where(resolved: true) }
end
