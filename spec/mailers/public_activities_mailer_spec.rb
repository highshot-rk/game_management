# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PublicActivitiesMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }
  let!(:activity) { game.create_activity 'create', owner: game.user, recipient: user }

  subject { described_class.notify(activity.id) }

  it 'send a notification to an user' do
    expect(subject.to).to eq([user.email])
    expect(subject.body.encoded).to include(root_url, game_path(id: game.slug))
  end
end
