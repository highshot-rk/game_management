module GamesHelper
  def parse_markdown(text)
    markdown = Redcarpet::Markdown.new(MarkdownRenderer, hard_wrap: true, autolink: true, space_after_headers: true)
    markdown.render(text.gsub(/\n+/m, "\n\n"))
  end

  def following_css(game)
    game.followed_by?(current_user) ? 'favourited' : ''
  end

  def preload_followers!(games, by: nil)
    if by
      ids = games.map(&:id)
      followings = Set.new(Following.where(user: by, game_id: ids).pluck(:game_id).flatten)
      games.each { |g| g.followed_by = followings.include?(g.id) }
    else
      games.each { |g| g.followed_by = false }
    end
  end

  def stats_color_for(increment)
    if !increment.finite? || increment.zero?
      '#ccc'
    elsif increment.positive?
      '#c60'
    else
      '#900'
    end
  end

  def not_nan(number)
    number.finite? ? number : '?'
  end

  def list_users(models, number_of_months)
    users = models.where('created_at > ?', number_of_months.months.ago).includes(:user).map(&:user).uniq
    users.map { |u| link_to(u.username, user_path(u.username)) }.join(', ').html_safe
  end

  def stats_list_since(stats)
    stats.reverse.map! do |e|
      [I18n.l(e.first, format: :short_date)] + e.last(2)
    end.to_json[1...-1]
  end
end
