# frozen_string_literal: true

# == Schema Information
#
# Table name: platforms
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  slug       :string           not null
#
# Indexes
#
#  index_platforms_on_name  (name) UNIQUE
#  index_platforms_on_slug  (slug) UNIQUE
#

class Platform < ApplicationRecord
  has_many :platform_links, dependent: :destroy
  has_many :download_links, through: :platform_links
  has_many :games, -> { uniq }, through: :download_links

  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]
end
