# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_comments_on_game_id  (game_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_8bbcb19e0f  (game_id => games.id)
#

class Comment < ApplicationRecord
  include PublicActivity::Common

  MIN_LENGTH = 10

  # 3rd Party Associations
  #
  has_closure_tree order: 'created_at DESC', dependent: :destroy
  counter_culture :game, column_name: proc { |comment| comment.parent_id.nil? ? 'comments_count' : nil }

  # Associations
  #
  belongs_to :user
  belongs_to :game

  has_many :activities,
    as: :trackable,
    class_name: 'PublicActivity::Activity',
    dependent: :destroy

  # Delegators & Scopes
  #
  delegate :user, to: :game, prefix: true
  delegate :username, to: :user

  scope :latest, -> { order(created_at: :desc) }
  scope :time_interval, -> { where('created_at > ?', 5.minutes.ago) }

  # Validations
  #
  validates :user, presence: true
  validates :game, presence: true
  validates :text, presence: true, length: { minimum: MIN_LENGTH }

  validate :check_spam!

  # The User has to wait 5 minutes to post again IF he PREVIOUSLY posted less then 2 minutes ago AND PREVIOUSLY posted a short comment (less then 20 characters) or PREVIOUSLY posted the same text or PREVIOUSLY posted a link
  # i18n-tasks-use t('activerecord.errors.models.comment.attributes.base.check_spam')
  def check_spam!
    if cooloff? &&
       ((user.comments.last.text.length < 50) ||
        user.comments.last.text.include?('http') ||
        (user.comments.last.text == text))
      errors.add(
        :base, :check_spam, cooloff: cooloff_time
      )
    end
  end

  # @param [Object] value
  def comment_id=(value)
    self.parent = Comment.find(value)
  end

  # @param [User] user
  def self.length_for(user)
    length = Comment.settings.length

    if user && user.level >= length.required_level
      length.enhanced
    else
      length.base
    end
  end

  def self.settings
    Settings.privileges.comments
  end

  private
  def cooloff?
    user.comments.time_interval.any?
  end

  def cooloff_time
    Integer((300.seconds - (Time.now - user.comments.time_interval.first.created_at.to_time)) / 60)
  end
end