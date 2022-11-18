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

RSpec.describe 'Events', type: :request do
  describe 'POST /games' do
    it 'fails when you\'re not logged in' do
      post events_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'creates nothing when some params are missing' do
      sign_up.update(staff: true)
      expect do
        post events_path, params: {
          event: {
            title: 'event title'
          }
        }
        expect(response).to render_template :new
      end.not_to change(Event, :count)
    end

    it 'creates a new event' do
      sign_up.update(staff: true)
      language = create(:language)
      expect do
        post events_path, params: {
          event: {
            title: 'event title',
            description: 'game description',
            website: 'www.google.it/',
            start_date: 1.week.from_now.strftime('%Y-%m-%d %H:%M %:z'),
            end_date: 2.weeks.from_now.strftime('%Y-%m-%d %H:%M %:z'),
            language_ids: [language.id, '']
          }
        }
        expect(response).to redirect_to event_path(id: Event.last.slug)
      end.to change(Event, :count).by(1)
      expect(Event.last).to have(1).languages
      expect(Event.last.website).to eq('http://www.google.it/')
    end
  end
end
