# frozen_string_literal: true
require 'rails_helper'

describe MedalsManager do
  subject { described_class.new(game) }

  context 'for games with many downloads' do
    let(:game) { create(:game, downloads_count: 1000) }
    let(:game2) { create(:game) }

    it 'generates a medal for downloads' do
      expect { subject.refresh_medals }.to change {
        Medal.where(key: 'd').count
      }.by(1)
    end

    it 'updates an existing medal for downloads' do
      medal = Medal.create(game: game, key: 'd', score: 5)
      expect do
        subject.refresh_medals
      end.to change { medal.reload.score }.to(1000)
    end

    it 'removes an loss medal' do
      medal = Medal.create(game: game, key: 'd', score: 5)
      expect do
        subject.refresh_medals
      end.to change { medal.reload.score }.to(1000)
    end
  end

  context 'for games with many ratings' do
    let(:game) { create(:game, ratings_count: 100) }
    let(:game2) { create(:game) }

    it 'generates a medal for ratings' do
      expect { subject.refresh_medals }.to change {
        Medal.where(key: 'v').count
      }.by(1)
    end

    it 'updates an existing medal for ratings' do
      medal = Medal.create(game: game, key: 'v', descending: true, score: 5)
      expect do
        subject.refresh_medals
      end.to change { medal.reload.score }.to(100)
      expect(Medal.where(key: 'v').last).not_to be_descending
    end

    it 'removes an loss medal' do
      subject = described_class.new(game2)
      Medal.create(game: game2, key: 'v', score: 100)
      expect do
        subject.refresh_medals
      end.to change { Medal.where(key: 'v').count }.by(-1)
    end
  end

  context 'for games with high rank' do
    let(:game) { create(:game, ratings_abs: 1) }

    it 'gives the chart medal' do
      expect do
        subject.refresh_medals
      end.to change { Medal.where(key: 't').count }.by(1)
      expect(Medal.where(key: 't').last).to be_descending
    end

    it 'updates the chart medal' do
      medal = Medal.create(game: game, key: 't', score: 3)
      expect do
        subject.refresh_medals
      end.to change { medal.reload.score }.to(1)
      expect(Medal.where(key: 't').last).to be_descending
    end
  end
end
