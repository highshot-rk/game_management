# frozen_string_literal: true
FactoryGirl.define do
  factory :following do
    association :game
    association :user
  end
end
