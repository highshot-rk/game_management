# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username#{n}" }
    sequence(:email)    { |n| "user-#{n}@example.com" }
    sequence(:password) { '12345678' }
    sequence(:password_confirmation) { '12345678' }

    before(:create) do |model, _params|
      model.skip_confirmation!
    end
  end
end
