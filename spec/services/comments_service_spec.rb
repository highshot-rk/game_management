# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsService do
  let!(:user) { create(:user) }
  let!(:game) { create(:game) }
  let(:comment) { create(:comment, game: game) }

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'Comment') }

  subject { described_class.new(text: 'hi', user: user, game: game) }

  describe '#create' do
    it 'creates a comment' do
      expect(PublicActivitiesMailer).to receive(:notify).exactly(1).times
        .and_return(double(deliver_later: nil))
      create(:following, user: game.user, game: game)
      following2 = create(:following, game: game)
      expect do
        expect do
          expect { subject.create }.to change(Comment, :count).by(1)
        end.to change { user.reload.score }.by(10)
      end.to change { notifications.count }.by(2)
      expect(notifications.map(&:recipient)).to contain_exactly(game.user, following2.user)
    end

    it 'creates an answer' do
      expect(PublicActivitiesMailer).to receive(:notify).exactly(2).times
        .and_return(double(deliver_later: nil))
      subject = described_class.new(text: 'hi', user: user, game: game, parent: comment)
      expect do
        expect do
          expect { subject.create }.to change(Comment, :count).by(1)
        end.to change { user.reload.score }.by(10).and(change { comment.children.count }.by(1))
      end.to change { notifications.count }.by(2)
      expect(notifications.map(&:recipient)).to contain_exactly(game.user, comment.user)
    end
  end

  describe '#destroy' do
    let!(:comment) { create(:comment, game: game, user: user) }

    subject { described_class.new(id: comment.id) }

    it 'destroys an comment' do
      expect(PublicActivitiesMailer).not_to receive(:notify)
      expect do
        expect { subject.destroy }.to change(Comment, :count).by(-1)
      end.to change { user.reload.score }.by(-10)
    end
  end
end
