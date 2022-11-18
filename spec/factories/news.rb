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

FactoryGirl.define do
  factory :news do
    sequence(:text) { |n| "News content #{n}" }
    association :user
    association :game
  end
end
