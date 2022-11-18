# frozen_string_literal: true
class StatsCalculator
  PERIOD = 2.weeks.ago

  def initialize(game)
    @game = game
  end

  def downloads_total
    @game.downloads_count
  end

  def downloads_today
    @downloads_total ||= stats.first.third
  end

  def downloads_this_week
    @downloads_this_week ||= stats.take(7).map(&:third).sum
  end

  def downloads_last_week
    @downloads_last_week ||= stats.last(7).map(&:third).sum
  end

  def downloads_increases
    ((downloads_this_week / downloads_last_week.to_f - 1) * 100).round(1)
  end

  # + 1, since you are visiting it right now!
  def visits_total
    @game.visits_count + 1
  end

  def visits_today
    stats.first.second
  end

  def visits_this_week
    stats.take(7).map(&:second).sum
  end

  def visits_last_week
    stats.last(7).map(&:second).sum
  end

  def visits_increases
    ((visits_this_week / visits_last_week.to_f - 1) * 100).round(1)
  end

  def active_views
    visits_total > 0 ? (downloads_total * 100 / visits_total.to_f).round(1) : 0
  end

  def rank
    @game.ratings_chart
  end

  def rank_last_days
    @game.ratings_chart_last_days(31)
  end

  def followings_rank
    @game.followings_chart
  end

  def downloads_rank
    @game.downloads_chart
  end

  def engagement
    @game.ratings_count + @game.comments_count + @game.followings_count
  end

  def stats
    @stats ||= Array.new(14) do |i|
      date = i.days.ago.to_date
      if base_query[date]
        [date] + base_query[date]
      else
        [date, 0, 0]
      end
    end
  end

  def post_news_invite
    @game.news_count > 0 && @game.followings_count > 10 && @game.updated_since?(30) && @game.release_type(:demo)
  end

  private

  def base_query
    @base_query ||= @game.stats.since(PERIOD).to_a.map do |e|
      [e[0], e[1..-1]]
    end.to_h
  end
end