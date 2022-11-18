require 'rails_helper'

RSpec.describe NewLeaderJob, type: :job do
  let!(:score) { create(:score, value: 100) }
  let!(:score2) { create(:score, value: 90, game: game) }
  let!(:game) { score.game }

  let(:notifications) { PublicActivity::Activity.all }

  it 'sends the notifications' do
    expect do
      Sidekiq::Testing.inline! do
        described_class.perform_now(score2.user, game)
      end
    end.to change(notifications, :count).by(3).and(
      change { PublicActivitiesMailer.deliveries.count }.by(3)
    )
  end

  it 'works if the current leader is null' do
    expect do
      Sidekiq::Testing.inline! do
        described_class.perform_now(nil, game)
      end
    end.to change(notifications, :count).by(2).and(
      change { PublicActivitiesMailer.deliveries.count }.by(2)
    )
  end

  it 'fails to send notification if the old leader is the same' do
    expect do
      expect do
        Sidekiq::Testing.inline! do
          described_class.perform_now(score.user, game)
        end
      end.not_to change(notifications, :count)
    end.not_to(change { PublicActivitiesMailer.deliveries.count })
  end
end
