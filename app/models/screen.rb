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

class Screen < Resource
  after_save :set_game_screen
  after_destroy :unset_game_screen

  belongs_to :game, inverse_of: :screens
  has_one :for_game, class_name: Game

  protected

  def set_game_screen
    game.update_attribute(:screen_id, id) if game.screen.blank?
  end

  def unset_game_screen
    return unless game.screen_id == id
    another_screen = game.screens.where.not(id: id).first
    game.update_attribute(:screen_id, another_screen.try(:id))
  end
end
