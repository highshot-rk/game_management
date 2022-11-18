# frozen_string_literal: true
FactoryGirl.define do
  factory :auth_code do
    association :game
    association :user
  end
end
