# frozen_string_literal: true
FactoryGirl.define do
  factory :homepage do
    sequence(:logo_file_name)    { |n| "file#{n}_name.png" }
    sequence(:logo_content_type) { 'image/png' }
    sequence(:logo_updated_at)   { Time.zone.now }
  end
end
