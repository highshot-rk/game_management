# frozen_string_literal: true
FactoryGirl.define do
  factory :score do
    association :game
    association :user
    value 10
  end
end
