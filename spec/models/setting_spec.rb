# frozen_string_literal: true
# == Schema Information
#
# Table name: settings
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  data               :json
#  language           :integer
#  notification_sound :boolean          default(TRUE)
#  adult_content      :boolean          default(FALSE)
#
# Indexes
#
#  index_settings_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_5676777bf1  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Setting, type: :model do
  always_has_a :user, User.new

  context 'on initialization' do
    it 'assigns with default values' do
      expect(described_class.new.data).to eq(described_class::DEFAULT_VALUES)
    end

    it 'does not override existing values' do
      subject.data['mail_ratings_create'] = false
      subject.user = create(:user)
      subject.save!
      expect(described_class.first.data).not_to eq(described_class::DEFAULT_VALUES)
    end
  end

  describe '#can_receive_mail?' do
    [
      [:rating, :create, nil],
      [:following, :create, nil],
      [:comment, :create, nil],
      [:comment, :answer, nil],
      [:event_subscription, :create, nil],
      [:event_subscription, :create, nil],

      [:news, :create, :follower],
      [:game, :create, :follower],
      [:comment, :create, :follower, true]
    ].each do |model, action, scope, negated|
      it "can receive mail from #{model}.#{action} #{scope}" do
        activity = create(model).create_activity(action)
        if negated
          expect(subject).not_to be_can_receive_mail(activity.key, scope)
        else
          expect(subject).to be_can_receive_mail(activity.key, scope)
        end
      end
    end

    it 'uses the default if not set' do
      subject.data.delete('mail_medal_create')
      expect do
        expect(subject).to be_can_receive_mail('medal.create', nil)
      end.not_to raise_error
    end

    it 'fails on missing key' do
      expect do
        subject.can_receive_mail?('some.create', nil)
      end.to raise_error(/mail_some_create/)
    end
  end
end
