# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MedalsService do
  let(:medal) { build(:medal, score: nil) }
  let(:medal2) { create(:medal, score: 1) }
  let(:medal3) { create(:medal, score: 100) }
  let(:medal4) { create(:medal, score: 1, story: [10]) }

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'Medal') }

  subject { described_class.new(score: 10) }

  describe '#update' do
    it 'creates a new medal' do
      expect(PublicActivitiesMailer).to receive(:notify).and_call_original
      expect do
        expect do
          expect { subject.update(medal) }.to change(Medal, :count).by(1)
        end.to change { medal.game.user.reload.score }.by(20)
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(medal.game.user)
    end

    it 'improves a medal' do
      expect(PublicActivitiesMailer).to receive(:notify).and_call_original
      medal2
      expect do
        expect do
          expect { subject.update(medal2) }.not_to change(Medal, :count)
        end.to change { medal2.game.user.reload.score }.by(20)
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(medal2.game.user)
    end

    it 'reduces the score of a medal' do
      expect(PublicActivitiesMailer).not_to receive(:notify)
      medal3
      expect do
        expect do
          expect { subject.update(medal3) }.not_to change(Medal, :count)
        end.not_to change { medal3.game.user.reload.score }
      end.not_to change { notifications.count }
    end

    it 'improves a medal to an already assigned value' do
      expect(PublicActivitiesMailer).to receive(:notify).and_call_original
      medal4
      expect do
        expect do
          expect { subject.update(medal4) }.not_to change(Medal, :count)
        end.not_to change { medal4.game.user.reload.score }
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(medal4.game.user)
    end
  end

  describe '#destroy' do
    it 'destroys a medal' do
      expect(PublicActivitiesMailer).not_to receive(:notify)
      medal2
      expect do
        expect { subject.destroy(medal2) }.to change(Medal, :count).by(-1)
      end.not_to change { notifications.count }
    end
  end
end
