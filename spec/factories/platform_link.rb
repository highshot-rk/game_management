# frozen_string_literal: true
FactoryGirl.define do
  factory :platform_link do
    association :platform
    association :download_link
  end
end
