# frozen_string_literal: true
# == Schema Information
#
# Table name: event_languages
#
#  id          :integer          not null, primary key
#  event_id    :integer          not null
#  language_id :integer          not null
#
# Indexes
#
#  index_event_languages_on_event_id_and_language_id  (event_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_2363ae925a  (language_id => languages.id)
#  fk_rails_2addfc6598  (event_id => events.id)
#

require 'rails_helper'

RSpec.describe EventLanguage, type: :model do
  # always_has_a :language, Language.new
  # always_has_a :event, Event.new
  always_has_unique :event_id, :language_id
end
