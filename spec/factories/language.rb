# frozen_string_literal: true
FactoryGirl.define do
  factory :language do
    sequence(:name) { |n| "Language Name #{n}" }
    sequence(:locale) { |n| "l#{n}" }
  end
end
