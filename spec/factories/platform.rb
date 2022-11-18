# frozen_string_literal: true
FactoryGirl.define do
  factory :platform do
    sequence(:name) { |n| "Platform Name #{n}" }
  end
end
