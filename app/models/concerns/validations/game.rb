module Validations
  module Game
    extend ActiveSupport::Concern
    included do
      validates :title, presence: true, length: { maximum: 25 }
      validates :description, presence: true, length: { in: 20..380 }
      validates :user, presence: true
      validates :genre, presence: true
      validates :tool, presence: true
      validates :author, presence: true
      validates :release_type, presence: true
      validates :slug, presence: true, uniqueness: true
      validates :website, uri: true
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.download_links.too_short')
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.download_links.too_long')
      validates :download_links, length: { in: 1..10 }
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.game_languages.too_short')
      validates :game_languages, length: { minimum: 1 }
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.screens.too_long')
      validates :screens, length: { maximum: 3 }
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.artworks.too_long')
      validates :artworks, length: { maximum: 3 }
      # i18n-tasks-use t('activerecord.errors.models.game.attributes.videos.too_long')
      validates :videos, length: { maximum: 1 }

      validate :check_download_links_destruction!
      validate :check_download_links_unique!
      validate :games_uploaded_today!, on: :create
    end

    # i18n-tasks-use t('activerecord.errors.models.game.attributes.download_links.links_repetition')
    def check_download_links_unique!
      urls = download_links.reject(&:marked_for_destruction?).map!(&:url).compact.to_a
      errors.add(
        :download_links, :links_repetition
      ) if urls.uniq.length != urls.length
    end

    def check_download_links_destruction!
      errors.add(
        :download_links, :too_short, count: 0
      ) if download_links.any? && download_links.all?(&:marked_for_destruction?)
    end

    # i18n-tasks-use t('activerecord.errors.models.game.attributes.base.limit_games_uploaded')
    def games_uploaded_today!
      errors.add(
        :base, :limit_games_uploaded
      ) if user.games.uploaded_today.size > 1
    end
  end
end
