# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  rating     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ratings_on_game_id              (game_id)
#  index_ratings_on_user_id              (user_id)
#  index_ratings_on_user_id_and_game_id  (user_id,game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_9c1f02ed77  (game_id => games.id)
#  fk_rails_a7dfeb9f5f  (user_id => users.id)
#

class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :game

  counter_culture :game

  validates :user, presence: true
  validates :game, presence: true
  validates :game_id, uniqueness: { scope: :user_id }

  validates :rating, presence: true, inclusion: 1..5

  after_create do |rating|
    rating.recount_votes_cache(:create)
  end

  after_update do |rating|
    rating.recount_votes_cache(:update)
  end

  after_destroy do |rating|
    rating.recount_votes_cache(:destroy)
  end

  scope :legacy, -> { where('created_at < ?', Time.new(2013).utc) }

  def legacy?
    created_at < Time.new(2013).utc
  end

  def recount_votes_cache(kind)
    execute_after_commit do
      delta_abs_record = calculate_new_rating(kind).to_i
      game.class.where(id: game.id).update_all(
        "ratings_abs = ratings_abs + #{delta_abs_record}"
      )
      game.update_column(:ratings_avg, game.ratings.average(:rating).to_f)
    end
  end

  def calculate_new_rating(kind)
    case kind
    when :create
      rating.to_i - 3
    when :update
      rating.to_i - rating_was.to_i
    when :destroy
      3 - rating.to_i
    else
      0
    end
  end

  include PublicActivity::Common
end
