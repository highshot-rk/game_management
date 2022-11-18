# frozen_string_literal: true
FactoryGirl.define do
  factory :medal do
    key 'test'
    score 10
    association :game
  end
end
