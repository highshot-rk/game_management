# frozen_string_literal: true

# == Schema Information
#
# Table name: tools
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tools_on_name  (name) UNIQUE
#

class Tool < ApplicationRecord
  has_many :games
  validates :name, presence: true, uniqueness: true
end
