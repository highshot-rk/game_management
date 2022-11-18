# frozen_string_literal: true
FactoryGirl.define do
  factory :rating do
    association :game
    association :user

    rating 1
  end
end
