# frozen_string_literal: true
FactoryGirl.define do
  factory :report do
    association :download_link, factory: :download_url
    association :user
    sequence(:message) { |n| "Report #{n}" }
  end
end
