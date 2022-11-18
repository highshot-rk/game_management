# frozen_string_literal: true
# == Schema Information
#
# Table name: news
#
#  id         :integer          not null, primary key
#  text       :text             not null
#  game_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_news_on_game_id  (game_id)
#  index_news_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7b6cb9343d  (user_id => users.id)
#  fk_rails_befb583e3e  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe News, type: :model do
  always_has_a :text
  always_has_a :game, Game.new
  always_has_a :user, User.new
end
