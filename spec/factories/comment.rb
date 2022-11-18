# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    association :game
    association :user

    sequence(:text) { |n| "This is a funny comment #{n}." }

    trait(:with_answers) do
      after(:create) do |comment|
        create_list(:comment, 2, parent: comment)
      end
    end
  end
end
