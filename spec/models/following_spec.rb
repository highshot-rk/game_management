# frozen_string_literal: true
# == Schema Information
#
# Table name: followings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_followings_on_game_id_and_user_id  (game_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_2897be8f82  (game_id => games.id)
#  fk_rails_40463234d9  (user_id => users.id)
#

require 'rails_helper'

describe Following, type: :model do
  always_has_a :user, User.new
  always_has_a :game, Game.new
end
