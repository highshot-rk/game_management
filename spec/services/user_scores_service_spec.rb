# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserScoresService do
  describe '#update' do
    let(:user) { create(:user, score: Settings.levels[1] - 10) }

    it 'adds a certain amount of score, sending notification' do
      expect(PublicActivitiesMailer).not_to receive(:notify)
      subject = described_class.new(user: user, action: :download, status: :create)
      expect do
        subject.update
      end.to change(PublicActivity::Activity, :count).by(1)
    end

    it 'reduces a certain amount of score, not sending notification' do
      subject = described_class.new(user: user, action: :rating, status: :destroy)
      expect do
        subject.update
      end.not_to change(PublicActivity::Activity, :count)
    end

    it 'adds a certain amount of score, leveling up' do
      expect(PublicActivitiesMailer).not_to receive(:notify)
      subject = described_class.new(user: user, action: :game, status: :create)
      expect do
        subject.update
      end.to change(PublicActivity::Activity, :count).by(2)
    end
  end

  describe '#recalculate' do
    let!(:user) { create(:user) }
    let!(:games) { create_list(:game, 2, user: user) }
    let!(:followings) { create_list(:following, 2, user: user) }
    let!(:ratings) { create_list(:rating, 2, user: user) }
    let!(:event_subscriptions) { create_list(:event_subscription, 2, user: user) }
    let!(:comments) { create_list(:comment, 2, user: user) }
    let!(:downloads) { create_list(:download, 2, user: user) }

    subject { described_class.new({}) }

    it 'recounts scores' do
      expect do
        subject.recalculate(user)
      end.to change { user.reload.score }
        .to(games.count * Settings.scores.game +
            event_subscriptions.count * Settings.scores.event +
            comments.count * Settings.scores.comment +
            followings.count * Settings.scores.following +
            downloads.count * Settings.scores.download +
            ratings.count * Settings.scores.rating)
    end
  end
end
