# frozen_string_literal: true
FactoryGirl.define do
  factory :supporter do
    association(:game)
    association(:user)
  end
end
