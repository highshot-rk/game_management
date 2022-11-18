# frozen_string_literal: true

# == Schema Information
#
# Table name: medals
#
#  id         :integer          not null, primary key
#  key        :string
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#  game_id    :integer
#  user_id    :integer
#  descending :boolean          default(FALSE), not null
#  story      :text             default([]), not null, is an Array
#
# Indexes
#
#  index_medals_on_game_id                      (game_id)
#  index_medals_on_key                          (key)
#  index_medals_on_key_and_game_id_and_user_id  (key,game_id,user_id) UNIQUE
#  index_medals_on_user_id                      (user_id)
#

class Medal < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :key, presence: true
  validates :score, presence: true

  validate :user_or_game
  include PublicActivity::Common

  has_many :activities,
           as: :trackable, class_name: 'PublicActivity::Activity',
           dependent: :destroy

  before_update do |medal|
    if medal.score_was != medal.score
      medal.story << medal.score_was
      medal.story.map!(&:to_i).uniq!
    end
  end

  def already_assigned?
    story.map(&:to_i).include?(score.to_i)
  end

  def improved?
    # Smaller is better
    if descending?
      score < score_was
    else
      score > score_was
    end
  end

  def user_or_game
    if game.blank? && user.blank?
      errors.add(
        :user_or_game, 'can\'t be blank.'
      )
    end
  end
end
