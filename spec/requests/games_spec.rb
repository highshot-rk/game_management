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

RSpec.describe 'Games', type: :request do
  describe 'POST /games' do
    it 'fails when you\'re not logged in' do
      post games_path
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'creates a new game with downloads' do
      sign_up
      language = create(:language)
      file = fixture_file_upload("#{Rails.root}/spec/assets/simple_game.zip", 'application/zip')
      expect do
        post games_path, params: {
          game: {
            title: 'game title',
            description: 'game description',
            download_links_attributes: {
              0 => { url: 'www.google.it' },
              3 => { url: 'www.google2.it', platform_ids: [create(:platform).id] },
              7 => { platform_ids: [] },
              4 => { file: file }
            },
            videos_attributes: {
              0 => { url: '' }
            },
            website: 'http://www.google.it/',
            language_ids: [language.id, ''],
            genre_id: create(:genre).id,
            tool_id: create(:tool).id,
            user: create(:user)
          }
        }
        # assert_select 'form > div', text: /odijfo/
        expect(response).to redirect_to game_path(id: 'game-title')
      end.to change(Game, :count).by(1)
      expect(Game.last).to have(3).download_links
      expect(Game.last.website).to eq('http://www.google.it/')
      expect(Game.last.indiepad_config).to be_nil
    end

    it 'creates a new game with indiepad' do
      sign_up
      language = create(:language)
      expect do
        post games_path, params: {
          game: {
            title: 'game title',
            description: 'game description',
            download_links_attributes: {
              0 => { url: 'www.google.it' }
            },
            videos_attributes: {
              0 => { url: '' }
            },
            indiepad: '1',
            indiepad_config_attributes: {
              data: { 0 => IndiepadConfig.new.data[0] }
            },
            website: 'http://www.google.it/',
            language_ids: [language.id, ''],
            genre_id: create(:genre).id,
            tool_id: create(:tool).id,
            user: create(:user)
          }
        }
        # assert_select 'form > div', text: /odijfo/
        expect(response).to redirect_to game_path(id: 'game-title')
      end.to change(Game, :count).by(1)
      expect(Game.last.indiepad_config.data).to eq(IndiepadConfig.new.data)
    end

    it 'creates no games without downloads' do
      sign_up
      language = create(:language)
      expect do
        post games_path, params: {
          game: {
            title: 'game title',
            description: 'game description',
            videos_attributes: {
              0 => { url: '' }
            },
            language_ids: [language.id, ''],
            genre_id: create(:genre).id,
            tool_id: create(:tool).id,
            user: create(:user)
          }
        }
        expect(response).to have_http_status 200
      end.not_to change(Game, :count)
    end

    it 'fails when some parameters are missing' do
      sign_up
      expect do
        post games_path,
             params: { game: { title: 'game title' } }
        expect(response).to have_http_status 200
        assert_select '#new_game'
      end.not_to change(Game, :count)
    end
  end

  describe 'PUT' do
    let(:user) { sign_up }
    let!(:game) { create(:game, user: user) }

    it 'updates a game, removing and adding things' do
      language = create(:language)
      file = fixture_file_upload(
        "#{Rails.root}/spec/assets/simple_game.zip", 'application/zip')
      expect do
        put game_path(id: game.slug), params: {
          game: {
            title: 'hello',
            description: 'game description',
            download_links_attributes: {
              0 => { id: game.download_links.first.id, _destroy: true },
              3 => { url: 'www.google.it', platform_ids: [create(:platform).id] },
              4 => { file: file, platform_ids: [create(:platform).id] }
            },
            language_ids: [language.id],
            genre_id: create(:genre).id,
            tool_id: create(:tool).id
          }
        }
        expect(response).to redirect_to(game_path(id: game.slug))
        game.reload
      end.to change(game, :title).to('hello')
      expect(game).to have(2).download_links
      expect(game.languages).to eq([language])
    end

    it 'does not duplicates video links' do
      video = create(:video, game: game)
      expect do
        put game_path(id: game.slug), params: {
          game: {
            videos_attributes: {
              0 => { id: video.id, url: video.url }
            }
          }
        }
      end.not_to change(game.videos, :count)
    end

    it 'can\'t update a game removing all downloads' do
      expect do
        put game_path(id: game.slug), params: {
          game: {
            download_links_attributes:
              game.download_links.map { |d| { id: d.id, _destroy: true } }
          }
        }
        expect(response).to have_http_status 200
        assert_select 'form > div',
                      text: 'Download links must be at least one'
      end.not_to change(game.download_links, :count)
    end

    it 'fails if validation fails' do
      expect do
        put game_path(id: game.slug), params: { game: { title: '' } }
        expect(response).to have_http_status(200)
        game.reload
        assert_select 'form > div', text: 'Title can\'t be blank'
      end.not_to change(game, :title)
    end

    it 'fails when you\'re not the game author' do
      game.update(user: create(:user))
      put game_path(id: game.slug), params: { game: { title: 'some' } }
      expect(response).to have_http_status 401
    end
  end

  context 'checks missing languages' do
    {
      downloaded: [:everytime, :last_week, :today],
      news: [:latest, :last_updated, :last_commented],
      chart: [:voted, :downloaded_everytime]
    }.each do |path, filters|
      I18n.available_locales.each do |locale|
        filters.each do |filter|
          it "loads #{path} #{filter} views in #{locale}" do
            expect do
              get send("#{path}_games_path", locale: locale, filter: filter)
            end.not_to raise_error
            expect(response).to be_success
          end
        end
      end
    end
  end

  describe '#edit' do
    let(:user) { sign_up }
    let(:game) { create(:game, user: user, author: 'prova') }
    it 'does not changes author when updating' do
      get edit_game_path(id: game.slug)
      assert_select '#game_author[value=?]'.dup, 'prova'
    end
  end
end
