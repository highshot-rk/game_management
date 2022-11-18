# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FollowingsService do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }

  subject { described_class.new(user: user, game: game) }
  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'Following') }

  describe '#create' do
    it 'creates a following' do
      expect(PublicActivitiesMailer).to receive(:notify)
        .and_return(double(deliver_later: nil))
      expect do
        expect { subject.update }.to change(Following, :count).by(1)
      end.to change { user.reload.score }.by(20)
        .and(change { notifications.count }.by(1))
      expect(notifications.map(&:recipient)).to contain_exactly(game.user)
    end
  end

  describe '#destroy' do
    let!(:following) { create(:following, game: game, user: user) }

    subject { described_class.new(id: following.id) }

    it 'destroys an following' do
      expect do
        expect { subject.destroy(following) }.to change(Following, :count).by(-1)
      end.to change { user.reload.score }.by(-20)
    end
  end
end
