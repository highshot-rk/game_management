# frozen_string_literal: true
FactoryGirl.define do
  factory :event_language do
    association :language
    association :event
  end
end
