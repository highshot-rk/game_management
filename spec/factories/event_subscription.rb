# frozen_string_literal: true
FactoryGirl.define do
  factory :event_subscription do
    association :user
    association :event
  end
end
