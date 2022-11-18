# frozen_string_literal: true
FactoryGirl.define do
  factory :download do
    association :download_link, factory: :download_url
    association :user
  end
end
