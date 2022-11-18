# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GamesService do
  let!(:user) { create(:user) }
  let!(:game_attributes) do
    build(:game, user: user).attributes.except('id', 'created_at', 'updated_at')
                            .merge(language_ids: [create(:language).id],
                                   download_links_attributes:
             {
               0 => { url: 'www.google.it' }
             })
  end

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'Game') }

  subject { described_class.new(game_attributes) }

  describe '#create' do
    let!(:admin) { create(:user, staff: true) }
    let(:other_game) { create(:game, user: user) }
    let!(:follower) { create(:following, game: other_game) }
    let!(:self_follower) { create(:following, user: user, game: other_game) }

    it 'creates an game' do
      expect do
        expect do
          expect { subject.create }.to change(Game, :count).by(1)
        end.to change { user.reload.score }.by(25)
      end.to change { notifications.count }.by(3)
      expect(notifications.map(&:recipient)).to include(follower.user, admin)
    end
  end

  describe '#update' do
    let!(:admin) { create(:user, staff: true) }
    let(:game) { create(:game, user: user) }

    it 'updates an game' do
      expect do
        expect { subject.update(game.id) }.to change { game.reload.title }
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(admin)
    end
  end

  describe '#destroy' do
    let!(:game) { create(:game, user: user) }

    subject { described_class.new(id: game.id) }

    it 'destroys an game' do
      expect do
        expect { subject.destroy }.to change(Game, :count).by(-1)
      end.to change { user.reload.score }.by(-25)
    end
  end
end
