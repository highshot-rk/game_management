module PublicActivitiesHelper
  def find_game(item)
    if item.nil?
      nil
    elsif item.is_a? Game
      item
    else
      item.try(:game)
    end
  end

  def find_event(item)
    case item
    when Event
      item
    else
      item.try(:event)
    end
  end

  def unread_class(activity)
    activity.unread ? 'unread-notifications' : ''
  end

  def find_medal(item)
    case item
    when Medal
      item
    else
      item.try(:medal)
    end
  end

  def find_comment(item)
    case item
    when Comment
      item
    else
      item.try(:comment)
    end
  end

  def find_following(item)
    case item
    when Following
      item
    else
      item.try(:following)
    end
  end

  def find_news(item)
    case item
    when News
      item
    else
      item.try(:news)
    end
  end

  def find_rating(item)
    case item
    when Rating
      item
    else
      item.try(:rating)
    end
  end
end
