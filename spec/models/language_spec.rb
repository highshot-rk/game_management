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

require 'rails_helper'

describe Language, type: :model do
  always_has_a :name
  always_has_unique :name
end
