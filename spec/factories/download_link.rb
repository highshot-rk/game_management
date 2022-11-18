# frozen_string_literal: true
FactoryGirl.define do
  factory :download_link do
    association :game

    after(:create) do |instance, _evaluator|
      instance.platforms << Platform.first(2)
    end

    factory :download_url do
      sequence(:url) { |n| "http://www.url#{n}.com/file.zip" }
    end

    factory :download_file do
      sequence(:file_file_name)    { |n| "file#{n}_name.zip" }
      sequence(:file_content_type) { 'application/zip' }
      sequence(:file_updated_at)   { Time.zone.now }
    end
  end
end
