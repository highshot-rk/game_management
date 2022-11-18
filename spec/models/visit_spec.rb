# frozen_string_literal: true
# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  count      :integer          default(1), not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_visits_on_game_id  (game_id)
#  index_visits_on_user_id  (user_id)
#

require 'rails_helper'

describe Visit, type: :model do
  context 'on save', transactions: true do
    let(:game) { create(:game) }

    it 'creates or updates stats' do
      expect { game.visits.create! }.to change(Stat, :count).by(1)
      expect { game.visits.create! }.not_to change(Stat, :count)
      expect(Stat.last.visits).to eq(2)
      expect(Stat.last.created_at).to eq(Date.current)
    end

    it 'creates or updates stats concurrently' do
      expect { game.visits.create! }.to change(Stat, :count).by(1)
      expect_any_instance_of(ActiveRecord::Relation).to receive(:pluck).with(:id).and_call_original
      allow_any_instance_of(ActiveRecord::Relation).to receive(:first_or_create!, &:create!)
      expect { game.visits.create! }.not_to change(Stat, :count)
      expect(Stat.last.visits).to eq(2)
      expect(Stat.last.created_at).to eq(Date.current)
    end
  end
end
