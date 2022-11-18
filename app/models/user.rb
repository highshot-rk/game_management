# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  legacy_password        :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  staff                  :boolean          default(FALSE), not null
#  notifications_count    :integer          default(0), not null
#  score                  :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  token                  :string
#  verified               :boolean          default(FALSE)
#  banned_at              :datetime
#  first_name             :string
#  surname                :string
#  phone_number           :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  include PublicActivity::Common
  include Chartable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :notifications,
           as: :recipient, class_name: 'PublicActivity::Activity',
           dependent: :destroy

  has_many :games, dependent: :destroy
  has_many :game_medals, through: :games, source: :medals
  has_many :ratings, dependent: :destroy
  has_many :downloads, dependent: :destroy
  has_many :your_games_total_visits, through: :games, source: :visits
  has_many :your_games_total_downloads, through: :games, source: :downloads
  has_many :downloaded_games, -> { distinct }, through: :downloads, source: :game
  has_many :event_subscriptions
  has_many :subscribed_events, through: :event_subscriptions, source: :event
  has_many :comments, dependent: :destroy
  has_many :commented_games, -> { distinct }, through: :comments, source: :game
  has_many :followings, through: :games
  has_many :followers, through: :followings, source: :user
  has_many :played_score_games, -> { distinct }, through: :scores, source: :game
  has_many :supported_games, -> { distinct }, through: :supporters, source: :game

  has_many :scores, dependent: :delete_all

  has_many :authored_games, class_name: 'Game', primary_key: 'username', foreign_key: 'author'

  has_many :followed, class_name: :Following, dependent: :destroy
  has_many :followed_games, through: :followed, source: :game
  has_many :rated_games, through: :ratings, source: :game
  has_many :auth_codes, dependent: :delete_all

  has_many :medals, dependent: :delete_all
  has_many :supporters
  has_many :reports, dependent: :destroy

  has_one :setting, dependent: :destroy

  include SitemapRefresh

  validates :terms_of_service, acceptance: true
  validates :username, uniqueness: { case_sensitive: false },
                       length: { in: 3..20 }, format: { without: /[\s\.]/ }

  scope :staff, -> { where(staff: true) }

  scope :map_game_ids, lambda {
    joins(:authored_games).group('users.id').pluck('users.id, array_agg(games.id)').to_h
  }

  def self.filter_by_level(users, level)
    ids = users.select { |u| u.level >= level }.map(&:id).uniq
    User.where(id: ids)
  end

  attr_accessor :username_or_email

  def level
    Settings.levels.index { |score_level| score < score_level } ||
      Settings.levels.length
  end

  def next_level
    Settings.levels[level] - score
  end

  def level_bar
    ((score - Settings.levels[level-1])*100) / (Settings.levels[level] - Settings.levels[level-1])
  end

  def just_level_up
    level_bar < 10 && level > 0
  end

  def near_to_level_up
    level_bar > 90
  end

  def user_title
    case level
      when 0..4 then I18n.t('levels.index.title_1')
      when 5..9 then I18n.t('levels.index.title_2')
      when 10..14 then I18n.t('levels.index.title_3')
      when 15..19 then I18n.t('levels.index.title_4')
      when 20..24 then I18n.t('levels.index.title_5')
      when 25..29 then I18n.t('levels.index.title_6')
      when 30..34 then I18n.t('levels.index.title_7')
      when 35..39 then I18n.t('levels.index.title_8')
      when 40..44 then I18n.t('levels.index.title_9')
      when 45..49 then I18n.t('levels.index.title_10')
      when 50..54 then I18n.t('levels.index.title_11')
      when 55..59 then I18n.t('levels.index.title_12')
      when 60..64 then I18n.t('levels.index.title_13')
      when 65..69 then I18n.t('levels.index.title_14')
      when 70..74 then I18n.t('levels.index.title_15')
      when 75..79 then I18n.t('levels.index.title_16')
      when 80..84 then I18n.t('levels.index.title_17')
      when 85..89 then I18n.t('levels.index.title_18')
      when 90..94 then I18n.t('levels.index.title_19')
      when 95..99 then I18n.t('levels.index.title_20')
      else I18n.t('levels.index.title_21')
    end
  end

  def online?
    updated_at > 20.minutes.ago
  end

  def current_settings
    @current_settings ||= setting || Setting.new(user_id: id)
  end

  def reload
    @current_settings = @sing_up_age = nil
    super
  end

  def sing_up_age
    @sing_up_age ||= ((Time.zone.today.to_datetime.to_i - created_at.to_i) / 1.year).floor
  end

  def created_since?(number_of_days)
    (Date.current - created_at.to_date).to_i <= number_of_days
  end

  def chart
    @chart ||= chart_position(:score)
  end

  def user_chart_last_days(number_of_days)
    subset = User.where('users.created_at >= ?', number_of_days.days.ago)
    @user_chart_last_days ||= chart_position(:score, subset)
    @user_chart_last_days ||= 0
  end

  # Background send emails
  # def send_devise_notification(notification, *args)
  #   devise_mailer.send(notification, self, *args).deliver_later
  # end

  def valid_password?(password)
    if legacy_password.nil?
      super
    elsif legacy_password == Digest::MD5.hexdigest(password)
      update(password: password,
             password_confirmation: password,
             legacy_password: nil)
      super
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (username_or_email = conditions.delete(:username_or_email))
      where(conditions.to_hash)
        .where('lower(username) = :value OR lower(email) = :value',
               value: username_or_email.downcase).first
    else
      find_by(conditions.to_hash)
    end
  end

  def has_unread_notifications?
    notifications_count > 0
  end

  def banned?
    banned_at.present?
  end

  # This method overrides auth for Devise, added banned_at check to handle
  # banned users
  def active_for_authentication?
    super && banned_at.nil?
  end
end
