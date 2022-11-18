# frozen_string_literal: true
FactoryGirl.define do
  factory :genre do
    sequence(:name) { |n| ['rpg', 'browsergame', 'platformaction'][n % 3] + ' ' + n.to_s }
  end
end
