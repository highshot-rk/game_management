# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id               :integer          not null, primary key
#  title            :string           not null
#  slug             :string           not null
#  description      :text             not null
#  release_type     :integer          default("complete"), not null
#  user_id          :integer
#  website          :string
#  author           :string           not null
#  screen_id        :integer
#  ratings_avg      :float            default(0.0), not null
#  ratings_abs      :float            default(0.0), not null
#  ratings_count    :integer          default(0), not null
#  screens_count    :integer          default(0), not null
#  artworks_count   :integer          default(0), not null
#  downloads_count  :integer          default(0), not null
#  comments_count   :integer          default(0), not null
#  news_count       :integer          default(0), not null
#  visits_count     :integer          default(0), not null
#  followings_count :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tool_id          :integer          not null
#  genre_id         :integer          not null
#  indiepad         :boolean          default(FALSE)
#  token            :string
#  long_description :text
#  last_news_at     :datetime
#  adult_content    :boolean          default(FALSE)
#  mobile_first     :boolean          default(FALSE)
#
# Indexes
#
#  index_games_on_author     (author)
#  index_games_on_genre_id   (genre_id)
#  index_games_on_screen_id  (screen_id) UNIQUE
#  index_games_on_slug       (slug) UNIQUE
#  index_games_on_token      (token) UNIQUE
#  index_games_on_tool_id    (tool_id)
#  index_games_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_28e79f0d94  (genre_id => genres.id)
#  fk_rails_b649ffd787  (tool_id => tools.id)
#  fk_rails_de9e6ea7f7  (user_id => users.id)
#

class Game < ApplicationRecord
  enum release_type: %i[complete demo minigame]

  include Scopes::Game
  include PublicActivity::Common
  include Associations::Game
  include Chartable

  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged finders]

  def slug_candidates
    %i[title title_and_sequence]
  end

  def title_and_sequence
    slug = normalize_friendly_id(title)
    sequence = Game.where("slug LIKE ?", "%#{slug}-%").count + 2
    "#{slug}-#{sequence}"
  end

  before_validation do |game|
    game.website = "http://#{game.website}" if game.website? && !game.website =~ %r{\A[a-zA-Z]+:\/\/}
    game.author ||= game.default_username
  end

  delegate :username, prefix: :default, to: :user, allow_nil: true

  accepts_nested_attributes_for :game_languages, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true,
                                         reject_if: :video_empty?
  accepts_nested_attributes_for :screens, :artworks, allow_destroy: true
  accepts_nested_attributes_for :download_links, allow_destroy: true,
                                                 reject_if: :download_empty?
  accepts_nested_attributes_for :indiepad_config, reject_if: :indiepad_disabled?

  has_one :monetisation, dependent: :destroy
  has_many :supporters

  def video_empty?(attributes)
    attributes[:url].blank?
  end

  def download_empty?(attributes)
    attributes[:url].blank? && attributes[:file].blank? &&
      attributes[:id].blank?
  end

  def indiepad_disabled?(_attributes)
    !indiepad?
  end

  include Validations::Game

  include SitemapRefresh

  include PgSearch
  pg_search_scope :search_all,
                  against: [
                    [:title, 'A'],
                    [:author, 'B'],
                    [:description, 'C']
                  ],
                  ignoring: :accents,
                  using: {
                    tsearch: { prefix: true }
                  }

  def last_news
    @last_news ||= news.order(created_at: :desc).first
  end

  def play_online
    @play_online ||= download_links.find_by(play_online: true)
  end

  def created_for
    (Date.current - created_at.to_date).to_i
  end

  def created_since?(number_of_days)
    (Date.current - created_at.to_date).to_i <= number_of_days
  end

  def updated_since?(number_of_days)
    return false unless last_news_at
    (Date.current - last_news_at.to_date).to_i <= number_of_days
  end

  def reload
    @last_news = @play_online = @followings_chart = @ratings_chart = @ratings_chart_last_days = nil
    super
  end

  def downloads_chart
    @downloads_chart ||= chart_position(:downloads_count)
  end

  def followings_chart
    @followings_chart ||= chart_position(:followings_count)
  end

  def ratings_chart
    @ratings_chart ||= chart_position(:ratings_abs)
  end

  def ratings_chart_last_days(number_of_days)
    subset = Game.where('games.created_at >= ?', number_of_days.days.ago)
    @ratings_chart_last_days ||= chart_position(:ratings_abs, subset)
    @ratings_chart_last_days ||= 0
  end

  attr_accessor :followed_by

  def followed_by?(user)
    return false unless user
    followed_by.nil? ? followings.where(user: user).any? : followed_by
  end

  def rating_from(user)
    ratings.where(user: user)&.first&.rating
  end

  def setup_with_relations(options = {})
    assign_attributes(options.except(:relations))
    self.author ||= user.try(:username)
    options[:relations].to_h.each do |name, count|
      rel = __send__(name)
      number_of_relations = count - rel.length
      [number_of_relations, 0].max.times { rel.build }
    end
    self
  end

  def recount_ratings_abs!
    if ratings.legacy.any?
      fail 'Can\'t recount votes for games with old votes. '\
           'You should recount manually'
    else
      update_column(
        :ratings_abs,
        ratings.sum(:rating) - ratings.count * 3
      )
    end
  end

  def monetisation_enabled?
    monetisation.present? ? monetisation.approved : false
  end
end
