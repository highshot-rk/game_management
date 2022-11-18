# frozen_string_literal: true
FactoryGirl.define do
  factory :resource do
    sequence(:file_file_name)    { |n| "file#{n}_name.png" }
    sequence(:file_content_type) { 'image/png' }
    sequence(:file_updated_at)   { Time.zone.now }

    association :game

    factory :artwork, class: Artwork do
    end

    factory :screen, class: Screen do
      trait :by_url do
        file_file_name nil
        file_content_type nil
        file_updated_at nil
        url 'http://www.example.com/image.png'
      end
    end
  end
end
