# frozen_string_literal: true
# == Schema Information
#
# Table name: event_subscriptions
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_event_subscriptions_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_570823d7e3  (event_id => events.id)
#  fk_rails_5fbb25ac5c  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe EventSubscription, type: :model do
  always_has_a :user, User.new
  always_has_a :event, Event.new
  always_has_unique :event_id, :user_id
end
