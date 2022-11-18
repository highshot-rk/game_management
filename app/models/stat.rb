# frozen_string_literal: true

# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  game_id    :integer          not null
#  downloads  :integer          default(0), not null
#  visits     :integer          default(0), not null
#  created_at :date             not null
#
# Indexes
#
#  index_stats_on_game_id_and_created_at  (game_id,created_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_6ab267ccd4  (game_id => games.id)
#

class Stat < ApplicationRecord
  belongs_to :game

  validates :game, presence: true
  validates :game_id, uniqueness: { scope: :created_at }

  scope :since,
        lambda { |since|
          order(created_at: :desc)
            .where('created_at > ?', since)
            .pluck(:created_at, :visits, :downloads)
        }

  scope :today_by_game, ->(game_id) { where(game_id: game_id).where('created_at = current_date') }

  def self.create_or_increment!(game_id, counters = {})
    query = today_by_game(game_id)
    stat = query.first_or_create!
    update_counters stat.id, counters
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
    update_counters query.pluck(:id), counters
  end
end
