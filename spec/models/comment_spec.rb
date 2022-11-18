# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_comments_on_game_id  (game_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_8bbcb19e0f  (game_id => games.id)
#

require 'rails_helper'

describe Comment, type: :model do
  always_has_a :user, User.new
  always_has_a :game, Game.new
  always_has_a :text
end
