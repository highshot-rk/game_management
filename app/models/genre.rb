# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_genres_on_name  (name) UNIQUE
#

class Genre < ApplicationRecord
  has_many :games
  validates :name, presence: true, uniqueness: true

  def to_translated_s
    I18n.t("genres.genre.#{name.downcase.gsub(/[^a-z]+/, '')}")
  end
end
