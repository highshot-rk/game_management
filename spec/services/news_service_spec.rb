# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NewsService do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'News') }

  subject { described_class.new(text: 'hi', user: user, game: game) }

  describe '#create' do
    it 'creates a news' do
      expect(PublicActivitiesMailer).to receive(:notify).twice.and_return(double(deliver_later: nil))
      create(:following, user: user, game: game)
      following = create(:following, game: game)
      expect do
        expect { subject.create }.to change(News, :count).by(1)
      end.to change { notifications.count }.by(2)
      expect(notifications.map(&:recipient)).to include(following.user)
    end
  end
end
