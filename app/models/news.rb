# frozen_string_literal: true

# == Schema Information
#
# Table name: news
#
#  id         :integer          not null, primary key
#  text       :text             not null
#  game_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_news_on_game_id  (game_id)
#  index_news_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_7b6cb9343d  (user_id => users.id)
#  fk_rails_befb583e3e  (game_id => games.id)
#
class News < ApplicationRecord
  include PublicActivity::Common

  MIN_LENGTH = 10

  # Associations
  #
  has_many :activities, as: :trackable,
    class_name: 'PublicActivity::Activity',
    dependent: :destroy

  belongs_to :game, touch: :last_news_at
  belongs_to :user

  # Validations
  #
  validates :text, presence: true
  validates :text, length: { minimum: MIN_LENGTH }
  validate :check_spam!

  # Other
  #
  # REVIEW: Is this really needed? Is the rails, counter_cache: true, not good enough?
  #
  counter_culture :game
  delegate :user, to: :game, prefix: true

  # Scopes
  #
  scope :latest, -> { order(created_at: :desc) }
  scope :time_interval, -> { where('created_at > ?', 5.minutes.ago) }

  # The User has to wait 5 minutes to post again news on the same game
  # i18n-tasks-use t('activerecord.errors.models.news.attributes.base.check_spam')
  def check_spam!
    errors.add(:base, :check_spam, cooloff: cooloff_time) if cooloff?
  end

  private

  def cooloff?
    game.news.time_interval.any?
  end

  def cooloff_time
    Integer((300.seconds - (Time.now - game.news.time_interval.first.created_at.to_time)) / 60)
  end
end