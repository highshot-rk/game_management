# frozen_string_literal: true
FactoryGirl.define do
  factory :visit do
    association :game
    association :user
    count 1
  end
end
