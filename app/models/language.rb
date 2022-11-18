# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  locale     :string           not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_languages_on_locale  (locale) UNIQUE
#  index_languages_on_name    (name) UNIQUE
#

class Language < ApplicationRecord
  has_many :game_languages, dependent: :destroy
  has_many :games, through: :game_languages
  validates :name, :locale, presence: true, uniqueness: true

  before_save do |language|
    language.locale = language.name[0..2].downcase unless language.locale
  end

  # restituisce la lingua di default
  # @return [Language]
  def self.default
    find_by(locale: I18n.default_locale)
  end
end
