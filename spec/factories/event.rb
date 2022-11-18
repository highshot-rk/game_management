# frozen_string_literal: true
FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Event #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:start) { 1.day.from_now }
    sequence(:end) { 2.days.from_now }
    association :user
  end
end
