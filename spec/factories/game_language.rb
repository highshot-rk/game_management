# frozen_string_literal: true
FactoryGirl.define do
  factory :game_language do
    association :language
    association :game
  end
end
