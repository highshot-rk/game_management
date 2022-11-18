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

class Artwork < Resource
end
