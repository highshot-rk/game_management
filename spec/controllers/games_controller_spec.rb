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

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
end
