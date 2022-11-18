# frozen_string_literal: true
module Associations
  module Game
    extend ActiveSupport::Concern
    included do
      has_one :indiepad_config, dependent: :delete

      has_many :links
      has_many :resources, dependent: :delete_all
      has_many :artworks, inverse_of: :game
      has_many :screens, inverse_of: :game
      has_many :videos, inverse_of: :game
      has_many :download_links, dependent: :destroy
      has_many :downloadable_links, -> { where(play_online: false) }, class_name: 'DownloadLink'
      has_many :online_links, -> { where(play_online: true) }, class_name: 'DownloadLink'
      has_many :platforms, -> { distinct }, through: :download_links
      has_many :downloads, through: :download_links
      has_many :ratings, dependent: :delete_all
      has_many :visits, dependent: :delete_all
      has_many :news, dependent: :delete_all

      has_many :scores, dependent: :delete_all
      has_one :max_score, -> { where(name: nil).order(value: :desc).order(updated_at: :asc).limit(1) }, class_name: 'Score'

      has_many :medals, dependent: :delete_all

      has_many :stats, dependent: :delete_all

      has_many :game_languages, dependent: :delete_all
      has_many :languages, -> { distinct }, through: :game_languages

      has_many :followings, dependent: :delete_all

      has_many :comments, dependent: :delete_all
      has_many :auth_codes, dependent: :delete_all

      belongs_to :screen

      belongs_to :user
      belongs_to :user_author, class_name: 'User', foreign_key: 'author', primary_key: 'username'
      belongs_to :genre
      belongs_to :tool

      has_many :activities,
               as: :trackable, class_name: 'PublicActivity::Activity',
               dependent: :destroy
    end
  end
end
