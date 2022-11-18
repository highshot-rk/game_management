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

describe Game, type: :model do
  always_has_a :title
  always_has_a :genre, Genre.new
  always_has_a :tool, Tool.new
  always_has_a :author
  always_has_a :description
  always_has_a :user, User.new

  always_has_unique :slug

  describe '#max_score' do
    let!(:game) { create(:game) }
    let!(:score) { create(:score, game: game, value: 1) }
    let!(:max_score) { create(:score, game: game, value: 100) }

    it 'returns the max score' do
      expect(game.max_score).to eq(max_score)
    end
  end

  describe 'foreign_key dependencies' do
    it 'destroyes a game if it has an auth_code' do
      auth_code = create(:auth_code)
      expect { auth_code.game.destroy }.not_to raise_error
    end
  end

  describe '#user_author' do
    let(:user) { create(:user) }
    let(:game_with_author) { create(:game, author: user.username) }
    let(:game) { create(:game) }
    it 'finds users by author name' do
      expect(game_with_author.user_author).to eq(user)
    end

    it 'finds no user if it\'s missing' do
      expect(game.user_author).to be_nil
    end
  end

  it 'validates #website as an uri' do
    subject.website = nil
    expect(subject).to have(0).errors_on(:website)
    subject.website = 'http://www.google.it'
    expect(subject).to have(0).errors_on(:website)
    subject.website = '@djisfj8D9@∏[OPDJF\\'
    expect(subject).to have(1).errors_on(:website)
    subject.website = 'javascript:alert(0)'
    expect(subject).to have(1).errors_on(:website)
    subject.website = 'myprotocol://google.it'
    expect(subject).to have(1).errors_on(:website)
  end

  it 'auto-assigns an author given a username' do
    game = create(:game, author: nil)
    expect(game.author).to eq(game.default_username)
    expect(game.author).to eq(game.user.username)
  end

  it 'has at least one language' do
    expect(subject).to have(1).error_on(:game_languages)
    subject.languages << Language.new
    expect(subject).to have(0).error_on(:game_languages)
  end

  it 'has at least one download_link and at most 10' do
    expect(subject).to have(1).error_on(:download_links)
    subject.download_links << DownloadLink.new
    expect(subject).to have(0).error_on(:download_links)
    subject.download_links += Array.new(10) { DownloadLink.new }
    expect(subject).to have(1).error_on(:download_links)
  end

  [[:artworks, 3], [:screens, 3], [:videos, 1]].to_h.each do |resource, max|
    it "has at most #{max} #{resource}" do
      class_name = resource.to_s.classify.constantize
      expect(subject).to have(0).error_on(resource)
      max.times { subject.public_send(resource) << class_name.new }
      expect(subject).to have(0).error_on(resource)
      subject.public_send(resource) << class_name.new
      expect(subject).to have(1).error_on(resource)
    end

    it "validates #{resource} max number also with nested attribute" do
      attributes = {}
      attributes[:"#{resource}_attributes"] = (max + 1).times.to_a
                                                       .map! { |i| [i + 1, { url: 'http://google.it' }] }.to_h
      subject = described_class.new(attributes)
      expect(subject).to have(max + 1).public_send(resource)
      expect(subject).to have(1).error_on(resource)
    end
  end

  it 'avoids download_link deletion with nested attributes' do
    game = create(:game, :with_downloads)
    game.download_links_attributes =
      game.download_links.map { |d| { id: d.id, _destroy: true } }
    expect(game.download_links[0]).to be_marked_for_destruction
    expect(game).to have(1).error_on(:download_links)
  end

  it 'updates download_link platform of a game with nested attributes' do
    game = create(:game, :with_downloads)
    platform = create(:platform)
    download = game.download_links.first
    expect do
      game.download_links_attributes = {
        2 => {
          id: download.id,
          platform_ids: [platform.id.to_s, '']
        }
      }
      game.save!
      expect(download.reload.platforms).to eq([platform])
    end.to change(PlatformLink, :count).by(1)
  end

  it 'creates a game from nested attributes' do
    langs = create_list(:language, 2)
    platforms = create_list(:platform, 2)
    game = Game.new(
      title: 'title', description: 'my_description',
      download_links_attributes: {
        0 => { url: 'www.google.it' },
        3 => { url: 'www.google2.it', platform_ids: platforms.map(&:id) },
        7 => { platform_ids: [] }
      },
      language_ids: langs.map(&:id),
      genre_id: create(:genre).id,
      tool_id: create(:tool).id,
      user: create(:user)
    )
    game.validate
    expect(game.errors).to be_empty
    game.save!
    expect(game.download_links).to have(2).elements
    expect(game.download_links.last.platforms).to eq(platforms)
    expect(game.languages).to eq(langs)
  end

  it 'gives an error on duplicate links' do
    platforms = create_list(:platform, 2)
    game = Game.new(
      title: 'title', description: 'my_description',
      download_links_attributes: {
        0 => { url: 'www.google.it' },
        1 => { url: 'www.google.it', platform_ids: platforms.map(&:id) }
      },
      language_ids: create_list(:language, 2).map(&:id),
      genre_id: create(:genre).id,
      tool_id: create(:tool).id,
      user: create(:user)
    )
    expect(game).to have(1).error_on(:download_links)
  end

  describe '#setup_with_relations' do
    let(:user) { create(:user) }

    it 'creates a new game respecting parameters' do
      game = Game.new.setup_with_relations(
        user: user,
        relations: {
          download_links: 1,
          screens: 3,
          artworks: 3
        }
      )
      expect(game).to be_new_record
      expect(game.download_links).to have(1).item
      expect(game.artworks).to have(3).items
      expect(game.screens).to have(3).items
    end
  end
end
