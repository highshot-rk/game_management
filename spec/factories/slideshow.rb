# frozen_string_literal: true
FactoryGirl.define do
  factory :slideshow do
    sequence(:image_file_name)    { |n| "file#{n}_name.png" }
    sequence(:image_content_type) { 'image/png' }
    sequence(:image_updated_at)   { Time.zone.now }
    sequence(:url) { |n| "http://www.site#{n}.com" }
  end
end
