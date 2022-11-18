# frozen_string_literal: true
FactoryGirl.define do
  factory :tool do
    sequence(:name) { |n| "Tool Name #{n}" }
  end
end
