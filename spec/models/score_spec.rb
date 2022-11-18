# frozen_string_literal: true
# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  game_id    :integer          not null
#  user_id    :integer          not null
#  name       :string
#  value      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_scores_on_game_id                       (game_id)
#  index_scores_on_user_id                       (user_id)
#  index_scores_on_user_id_and_game_id_and_name  (user_id,game_id,name) UNIQUE
#  index_scores_on_value                         (value)
#
# Foreign Keys
#
#  fk_rails_41612d9bae  (game_id => games.id)
#  fk_rails_f5dcd5d06f  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Score, type: :model do
  always_has_a :user, User.new
  always_has_a :game, Game.new
end
