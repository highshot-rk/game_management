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

require 'rails_helper'

RSpec.describe Report, type: :model do
  always_has_a :download_link, DownloadLink.new
  always_has_a :user, User.new
end
