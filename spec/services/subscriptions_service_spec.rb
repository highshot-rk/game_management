# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubscriptionsService do
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }

  let(:notifications) { PublicActivity::Activity.where(trackable_type: 'EventSubscription') }
  subject { described_class.new(event: event, user: user) }

  describe '#create' do
    it 'creates an event subscription' do
      expect(PublicActivitiesMailer).to receive(:notify).and_return(double(deliver_later: nil))
      expect do
        expect do
          expect { subject.update }.to change(EventSubscription, :count).by(1)
        end.to change { user.reload.score }.by(20)
      end.to change { notifications.count }.by(1)
      expect(notifications.map(&:recipient)).to contain_exactly(event.user)
    end
  end

  describe '#destroy' do
    let!(:subscription) { create(:event_subscription, event: event, user: user) }

    it 'destroys an event subscription' do
      expect do
        expect { subject.destroy(subscription) }.to change(EventSubscription, :count).by(-1)
      end.to change { user.reload.score }.by(-20)
    end
  end
end
