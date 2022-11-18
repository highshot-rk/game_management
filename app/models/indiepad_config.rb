# == Schema Information
#
# Table name: indiepad_configs
#
#  id      :integer          not null, primary key
#  data    :json             not null
#  game_id :integer          not null
#
# Indexes
#
#  index_indiepad_configs_on_game_id  (game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_de8e6fcffa  (game_id => games.id)
#

class IndiepadConfig < ApplicationRecord
  belongs_to :game

  after_initialize do
    self.data ||= begin
      [Settings.indiepad.default.map { |k, _| [k, k] }.to_h.stringify_keys]
    end
  end

  validate :data_type!
  validates :data, length: { maximum: 4 }

  validates :game_id, uniqueness: true

  def data_type!
    errors.add(:data, :invalid) unless data.is_a?(Array)
    data.each do |e|
      missing_keys = self.class.required_keys - e.keys
      errors.add(:data, :invalid, missing_keys: missing_keys) if missing_keys.any?
    end
  end

  def self.required_keys
    @required_keys ||= Settings.indiepad.default.keys.map(&:to_s).freeze
  end
end
