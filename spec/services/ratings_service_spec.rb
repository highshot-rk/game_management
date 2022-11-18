# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RatingsService do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }

  subject { described_class.new(game: game, user: user) }

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'Rating') }

  describe '#update' do
    it 'creates an rating' do
      expect do
        expect do
          expect { subject.update(5) }.to change(Rating, :count).by(1)
        end.to change { user.reload.score }.by(5)
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(game.user)
    end

    it 'updates an rating' do
      create(:rating, game: game, user: user)
      expect do
        expect do
          subject.update(5)
        end.not_to change { user.reload.score }
      end.not_to change { notifications.count }
    end
  end
end
