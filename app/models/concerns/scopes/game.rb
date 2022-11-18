# frozen_string_literal: true
module Scopes
  module Game
    extend ActiveSupport::Concern

    included do
      scope :filter, ->(params) { FilterParser.new(self, params).filter }

      scope :not_downloaded_by, ->(user) { where.not(id: user.downloaded_games) }

      scope :order_by_download_date, lambda {
        select('games.*, MAX(downloads.created_at) as downloads_created_at')
          .order('downloads_created_at DESC')
          .group('games.id')
      }

      scope :having_same_relation, lambda { |relation_name, games|
        joins(relation_name).where(relation_name => { id: games.joins(relation_name).select(relation_name => :id) })
      }

      scope :with_ids_keeping_order, lambda { |ids|
        joins("JOIN (SELECT * FROM unnest(array[#{ids.join(',')}]) with ordinality) as x (id, ordering) on games.id = x.id")
          .order('x.ordering')
      }

      scope :where_subquery, lambda { |match, subquery|
        where(match.gsub('?', subquery.to_sql))
      }

      scope :not_adults, -> { where(adult_content: false) }

      scope :having_scores, lambda {
        joins(:scores)
          .group(:id)
          .select('games.*, max(scores.updated_at) as supdated_at')
          .order('supdated_at DESC')
      }

      scope :best_players, lambda {
        joins(:scores)
          .group(:id)
          .order('updated_at DESC, max(scores.value) DESC')
      }

      scope :latest, -> { order(created_at: :desc) }
      scope :uploaded_today, -> { where('created_at > ?', 1.day.ago) }

      scope :last_commented, lambda {
        joins(:comments)
          .select('"games".*, '\
            'MAX("comments"."created_at") as comments_created_at')
          .group('"games"."id"')
          .order('"comments_created_at" DESC')
      }

      scope :last_updated, lambda {
        # order(updated_at: :desc)
        joins(:news)
          .select('games.*, MAX(news.created_at) as news_created_at')
          .order('news_created_at DESC').group('games.id')
      }

      scope :voted_everytime, lambda {
        order(ratings_abs: :desc)
          .order(created_at: :desc)
      }

      scope :followed_everytime, lambda {
        order(followings_count: :desc)
          .order(created_at: :desc)
      }

      scope :voted, lambda {
        where('games.created_at > ?', 6.months.ago)
          .order(ratings_abs: :desc)
          .order(created_at: :desc)
      }

      scope :followed, lambda {
        where('games.created_at > ?', 6.months.ago)
          .order(followings_count: :desc)
          .order(created_at: :desc)
      }

      scope :most_downloaded, lambda {
        where('games.created_at > ?', 6.months.ago)
          .order(downloads_count: :desc)
      }

      scope :updated_since, lambda { |days|
        where('games.last_news_at > (CURRENT_DATE - INTERVAL \'? days\')', days)
      }

      scope :news_last_month, lambda {
        where('games.last_news_at > ?', 30.days.ago)
          .order(last_news_at: :desc)
      }

      scope :downloaded_today, lambda {
        fill_downloads_at(1.day.ago)
      }

      scope :downloaded_last_week, lambda {
        fill_downloads_at(1.week.ago)
      }

      scope :downloaded_last_month, lambda {
        fill_downloads_at(30.days.ago)
      }

      scope :fill_downloads_at, lambda { |date|
        joins(sanitize_sql_array(['LEFT OUTER JOIN stats ON stats.game_id = games.id AND stats.created_at > ?', date]))
          .group('games.id')
          .order('SUM(COALESCE("stats"."downloads", 0)) DESC')
          .order('SUM(COALESCE("stats"."visits", 0)) DESC')
          .order('"games"."created_at" DESC')
        # joins(
        #   'LEFT OUTER JOIN download_links ON download_links.game_id = games.id ')
        #   .joins(
        #     sanitize_sql_array(
        #       ['LEFT OUTER JOIN downloads '\
        #        'ON downloads.download_link_id = download_links.id '\
        #        'AND downloads.created_at > ?', date]))
        #   .joins(
        #     sanitize_sql_array(
        #       ['LEFT OUTER JOIN visits ON visits.game_id = games.id '\
        #        'AND visits.created_at > ?', date]))
        #   .group('games.id')
        #   .order('SUM(COALESCE("downloads"."count", 0)) DESC')
        #   .order('SUM(COALESCE("visits"."count", 0)) DESC')
        #   .order('"games"."created_at" DESC')
      }

      scope :downloaded_everytime, lambda {
        order(downloads_count: :desc)
      }

      scope :downloaded, lambda { |time|
        joins(:downloads)
          .group('"games"."id"')
          .where('"downloads"."created_at" > ?', time)
          .order('SUM("downloads"."count") DESC')
      }

      scope :visited, lambda { |time|
        joins(:visits)
          .group('"games"."id"')
          .where('"visits"."created_at" > ?', time)
          .order('SUM("visits"."count") DESC')
      }

      scope :popular, lambda {
        where('ratings_count >= 4')
          .where('ratings_avg >= 3.8')
          .where('downloads_count >= 50')
          .where('comments_count >= 3')
          .order(created_at: :desc)
      }

      scope :never_commented, lambda {
        where('ratings_count >= 4')
          .where('ratings_avg >= 3.8')
          .where('downloads_count >= 400')
          .where('comments_count < 1')
          .random_order
      }

      scope :anniversary, lambda {
        where('extract(year from created_at) < ? AND extract(month from created_at) = ? AND extract(day from created_at) = ?', Time.current.year, Time.current.month, Time.current.day)
          .random_order
    }

      scope :over_1000_downloads, lambda {
        where('downloads_count > ? AND downloads_count < ?', 1000, 1150)
          .random_order
      }

      scope :indiepad, lambda {
        where(indiepad: true)
          .joins(:download_links)
          .where(download_links: { play_online: true })
          .order(downloads_count: :desc)
          .distinct
      }

      scope :online_and_mobile, lambda {
        where(mobile_first: true)
          .joins(:download_links)
          .where(download_links: { play_online: true })
          .order(downloads_count: :desc)
          .distinct
      }

      scope :with_screens, lambda {
        where.not(screen_id: nil)
      }

      scope :random_order, -> { order('random()') }

      scope :order_by_indiepad, -> { order('coalesce(games.indiepad, FALSE) DESC') }

      scope :random, lambda { |number|
        random_order.limit(number)
      }

      scope :suggested, lambda { |game|
        select_fragment = sanitize_sql_array(
          ['*, (author = ?) as suggested_author', game.author])
        select(select_fragment).where.not(id: game.id)
                               .order('suggested_author DESC').order('random()')
      }
    end
  end
end
