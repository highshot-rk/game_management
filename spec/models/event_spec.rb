# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  title               :string           not null
#  description         :text             not null
#  rules               :text
#  prizes              :text
#  website             :text
#  event_type          :integer          default("contest"), not null
#  start               :datetime         not null
#  end                 :datetime         not null
#  user_id             :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  screen_file_name    :string
#  screen_content_type :string
#  screen_file_size    :integer
#  screen_updated_at   :datetime
#  slug                :string           not null
#
# Indexes
#
#  index_events_on_slug     (slug) UNIQUE
#  index_events_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  always_has_a :title
  always_has_a :description

  it 'validates start to be before end' do
    subject.start = 1.week.ago
    subject.end = 2.weeks.ago
    expect(subject).to have(1).error_on(:end)
    subject.end = Time.zone.now
    expect(subject).to have(0).error_on(:end)
  end

  it 'validates nested event language' do
    languages = create_list(:language, 2)
    subject.language_ids = languages.map!(&:id)
    expect(subject).to have(0).errors
  end
end
