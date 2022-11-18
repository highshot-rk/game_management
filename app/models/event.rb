# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  title               :string           not null
#  description         :text             not null
#  rules               :text
#  prizes              :text
#  website             :text
#  event_type          :integer          default("contest"), not null
#  start               :datetime         not null
#  end                 :datetime         not null
#  user_id             :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  screen_file_name    :string
#  screen_content_type :string
#  screen_file_size    :integer
#  screen_updated_at   :datetime
#  slug                :string           not null
#
# Indexes
#
#  index_events_on_slug     (slug) UNIQUE
#  index_events_on_user_id  (user_id)
#

class Event < ApplicationRecord
  has_attached_file :screen, styles: { large: '800x800^', medium: '320x560>' },
                             processors: %i[thumbnail paperclip_optimizer]

  validates_attachment :screen,
                       content_type: { content_type: %r{\Aimage\/.*\Z} },
                       size: { less_than: 4.megabytes }

  has_many :event_subscriptions, dependent: :delete_all
  has_many :users, through: :event_subscriptions
  has_many :event_languages, dependent: :delete_all
  has_many :languages, through: :event_languages
  belongs_to :user
  has_one :fragment, as: :fragmentable

  include SitemapRefresh
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  before_validation do |event|
    event.website = "http://#{event.website}" if event.website? && !event.website.start_with?('http://', 'https://')
  end

  enum event_type: %i[contest mini_contest other]

  validates :title, :description, :user, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :website, uri: true

  # i18n-tasks-use t('activerecord.errors.messages.invalid_datetime')
  validates_datetime :start
  validates_datetime :end, on_or_after: :start, on_or_after_message: I18n.t('events.end_after_start')

  accepts_nested_attributes_for :event_languages, allow_destroy: true

  def subscribed?(user)
    event_subscriptions.where(user: user).any?
  end

  scope :active, lambda { |active|
    if active
      where('"end" > ?', Time.zone.now)
    else
      where('"end" < ?', Time.zone.now)
    end
  }

  scope :running, -> { active(true) }
  scope :ended, -> { active(false) }

  include AliasDateAttribute

  alias_date_attribute_with_format :start, '%Y-%m-%d %H:%M %:z', suffix: :date
  alias_date_attribute_with_format :end, '%Y-%m-%d %H:%M %:z', suffix: :date
end
