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

class Visit < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :game, presence: true

  counter_culture :game

  after_commit on: :create do
    update_stats
  end

  # TODO: Upgrade do postgresql 9.5
  def update_stats
    Stat.create_or_increment! game.id, visits: count

    # stat = Stat.where(game_id: game_id)
    #            .where('created_at = current_date')
    #            .first_or_initialize
    # stat.increment!(:visits, count)

    # On postgre 9.5 release
    # query = ['INSERT INTO stats (game_id, created_at, visits) '\
    #          'VALUES (:game_id, current_date, :visits_count) '\
    #          'ON CONFLICT (game_id, created_at) DO '\
    #          'UPDATE SET visits = visits + :visits_count;',
    #          game_id: game_id, visits_count: count]
    # self.class.connection.execute(
    #   ActiveRecord::Base.send(:sanitize_sql_array, query))
  end
end
