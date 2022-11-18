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

require 'rails_helper'

describe Genre, type: :model do
  always_has_a :name
  always_has_unique :name
end
