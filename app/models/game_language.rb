# frozen_string_literal: true

# == Schema Information
#
# Table name: game_languages
#
#  id          :integer          not null, primary key
#  game_id     :integer          not null
#  language_id :integer          not null
#
# Indexes
#
#  index_game_languages_on_game_id_and_language_id  (game_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_9364b58f3f  (game_id => games.id)
#  fk_rails_e3ce328a2e  (language_id => languages.id)
#

# i18n-tasks-use t('activerecord.models.game_languages')
class GameLanguage < ApplicationRecord
  belongs_to :language
  belongs_to :game

  delegate :name, to: :language

  validates :game_id, uniqueness: { scope: :language_id }
end
