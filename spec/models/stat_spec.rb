# frozen_string_literal: true
# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  game_id    :integer          not null
#  downloads  :integer          default(0), not null
#  visits     :integer          default(0), not null
#  created_at :date             not null
#
# Indexes
#
#  index_stats_on_game_id_and_created_at  (game_id,created_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_6ab267ccd4  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe Stat, type: :model do
  always_has_a :game, Game.new
end
