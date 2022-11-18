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

class Setting < ApplicationRecord
  class InvalidKeyError < ::StandardError; end

  belongs_to :user
  validates :user, presence: true

  DEFAULT_VALUES = {
    # Someone adds a vote to your game
    "mail_rating_create" => true,
    # I am followed by someone new
    "mail_following_create" => true,
    # Someone comments your game
    "mail_comment_create" => true,

    # Someone replies to your comment
    "mail_comment_answer" => true,
    # Someone mentions you
    "mail_comment_mention" => true,

    # Someone subscribes to your events
    "mail_event_subscription_create" => true,

    # Someone comments a game you follow
    "mail_comment_follower_create" => false,
    # Someone updates a game you follow
    "mail_follower_news_create" => true,
    # An user you follow uploaded a new game
    "mail_follower_game_create" => true,
    # You received a badge
    "mail_medal_create" => true,
    # You are the Best Player of a game
    "mail_user_game_new_leader" => true,
    # You are no more the Best Player of a game
    "mail_user_game_old_leader" => true,
    # There is a new Best Player
    "mail_user_game_other_leader" => true,
    # New Leader on your own game
    "mail_user_game_dev_leader" => true
  }.freeze

  after_initialize do
    self.data = DEFAULT_VALUES.dup if new_record? && !persisted?
  end

  before_save :data_to_boolean!

  def can_receive_mail?(key, scope)
    key = settings_key(:mail, key, scope)

    fail InvalidKeyError, "Invalid key #{key}" unless DEFAULT_VALUES.include?(key)

    data.include?(key) ? data[key] : DEFAULT_VALUES[key]
  end

  DEFAULT_VALUES.keys.each do |attribute|
    define_method(attribute) do
      data[attribute]
    end

    define_method("#{attribute}=") do |value|
      data[attribute] = value
    end
  end

  private

  def data_to_boolean!
    data.each do |key, value|
      data[key] = ["1", true, "yes"].include?(value)
    end
  end

  def settings_key(section, key, scope)
    formatted_key = key.tr(".", "_")
    scope ? "#{section}_#{scope}_#{formatted_key}" : "#{section}_#{formatted_key}"
  end
end
