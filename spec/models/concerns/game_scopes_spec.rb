# frozen_string_literal: true
require 'rails_helper'

describe 'Model Scoping:' do
  describe Game, type: :model do
    describe '#latest' do
      let(:games) do
        [create(:game), create(:game, created_at: 1.week.ago)]
      end

      it 'sorts games by creation date' do
        expect(Game.latest).to eq(games)
      end
    end

    describe '#last_commented' do
      let(:games) do
        output = [create(:game), create(:game)]
        create_list(:comment, 1, game: output.first)
        create_list(:comment, 2, game: output.last, created_at: 1.week.ago)
        output
      end

      it 'sorts games by comments creation date' do
        expect(games.count).to eq(Game.last_commented.length)
        expect(Game.last_commented).to eq(games)
      end
    end

    describe '#last_updated' do
      let(:games) do
        [create(:game), create(:game), create(:game)]
      end

      it 'sorts games by update date' do
        create(:news, game: games.first)
        expect(Game.last_updated).to eq(games.first(1))
        news = create(:news, game: games.second, created_at: 1.week.ago)
        expect(Game.last_updated).to eq(games.first(2))
        news.update(created_at: Time.zone.now)
        expect(Game.last_updated).to eq(games.first(2).reverse)
        create(:news, game: games.first)
        expect(Game.last_updated).to eq(games.first(2))
      end
    end

    describe '#random' do
      let!(:games) do
        create_list(:game, 3)
      end

      it 'get n elements at random' do
        result = Game.random(1)
        expect(result).to have(1).item
      end
    end

    describe '#suggested' do
      let!(:authored_games) { create_list(:game, 3, author: 'foo') }
      let!(:games) { create_list(:game, 3) }

      it 'gets all elements, putting foo\'s ones firsts' do
        games = Game.suggested(authored_games.first).to_a
        expect(games.first(2)).to include(*authored_games.last(2))
        expect(games.last(3)).not_to include(*authored_games)
      end
    end

    describe '#voted' do
      let!(:games) do
        [create(:game, ratings_abs: 3), create(:game, ratings_abs: 1),
         create(:game, ratings_abs: 2)]
      end
      it 'sorts games by voting date' do
        expect(Game.voted).to eq([games.first, games.third, games.second])
      end
    end

    describe '#downloaded_everytime' do
      let(:games) do
        [create(:game, downloads_count: 1), create(:game, downloads_count: 3)]
      end
      it 'sorts games by dowload_count' do
        expect(Game.downloaded_everytime).to eq(games.reverse)
      end
    end

    describe '#downloaded_today' do
      let!(:games) do
        games = create_list(:game, 9)
        3.times do |i|
          create_list(:visit, 3 - i, game: games[i + 3])
        end
        3.times do |i|
          links = create_list(:download_url, 3 - i, game: games[i])
          links.each do |link|
            create(:download, download_link: link)
          end
        end
        games
      end
      it 'gets filled to reach a filled list', transactions: true do
        expect(Game.downloaded_today.map(&:id).first(6)).to eq(
          games.map(&:id).first(6)
        )
        expect(Game.downloaded_today).to contain_exactly(*Game.all)
      end
    end

    describe '#downloaded' do
      let(:games) do
        output = create_list(:game, 3, :with_downloads)
        links = output.map(&:download_links).map(&:first)
        links.each_with_index do |link, i|
          old = 3.days.ago
          older = 3.months.ago
          create_list(:download, 3 - i, download_link: link)
          create_list(:download, 1 + i * 2,
                      created_at: old, download_link: link)
          create_list(:download, 8, created_at: older, download_link: link)
        end
        output
      end

      it 'sorts by downloaded today' do
        games
        today = Time.zone.today
        result = Game.downloaded(today)
        expect(count_actual_download_at(result, today)).to eq([3, 2, 1])
        expect(result.length).to eq(3)
        expect(result).to eq(games)
      end

      it 'sorts by downloaded this week' do
        games
        one_week = 1.week.ago
        result = Game.downloaded(one_week)
        expect(count_actual_download_at(result, one_week)).to eq([6, 5, 4])
        expect(result.length).to eq(3)
        expect(result).to eq(games.reverse)
      end

      it 'sorts by downloaded this year' do
        games
        one_year = 1.year.ago
        result = Game.downloaded(one_year)
        expect(count_actual_download_at(result, one_year)).to eq([14, 13, 12])
        expect(result.length).to eq(3)
        expect(result).to eq(games.reverse)
      end

      def count_actual_download_at(result, date)
        result.map(&:downloads)
              .map { |d| d.where('downloads.created_at > ?', date) }
              .map { |d| d.sum(:count) }
      end
    end

    describe '#popular' do
      let(:games) do
        games = create_list(:game, 5, downloads_count: 50, comments_count: 5)
        create_list(:rating, 4, game: games.first, rating: 4)
        create_list(:rating, 4, game: games.second, rating: 5)
        create_list(:rating, 2, game: games.third, rating: 5)
        create_list(:rating, 4, game: games.last, rating: 1)
        games
      end
      it 'sorts games by popular formula', transactions: true do
        expected = games.first(2)
        result = Game.popular
        expect(expected).to contain_exactly(*result)
      end
    end
  end
end

describe 'Search:' do
  describe Game, type: :model do
    describe '#search_all' do
      let(:tool) { create(:tool, name: 'my tool') }
      let(:games) do
        [create(:game), create(:game, title: 'the cat is on the table'),
         create(:game, description: 'The càt is òn the Table!'),
         create(:game, author: 'cat'), create(:game, tool: tool)
        ]
      end

      it 'works as a scope' do
        expect do
          expect(tool.games.search_all('title')).to eq([games.last])
        end.not_to raise_error
      end

      it 'returns games matching "cat"' do
        matching_games = search_in_ruby('cat')
        expect(Game.search_all('cat')).to contain_exactly(*matching_games)
      end

      it 'returns games matching "the cat is on the table"' do
        matching_games = search_in_ruby('the cat is on the table')
        expect(
          Game.search_all('the cat is on the table')
        ).to contain_exactly(*matching_games)
        expect(
          Game.search_all('tHE cat ìs on thè table')
        ).to contain_exactly(*matching_games)
      end

      it 'finds partial words' do
        matching_games = search_in_ruby('tabl')
        expect(
          Game.search_all('tabl')
        ).to contain_exactly(*matching_games)
      end

      def search_in_ruby(query)
        clean_query = clean(query)
        games.select do |game|
          search_game_by(game, clean_query)
        end
      end

      def search_game_by(game, clean_query)
        clean(game.title).include?(clean_query) ||
          clean(game.description).include?(clean_query) ||
          clean(game.author).include?(clean_query)
      end

      def clean(text)
        I18n.transliterate(text).downcase
      end
    end
  end
end

describe 'Filters:' do
  let!(:platform) { create(:platform) }
  describe Game, type: :model do
    let(:games) { create_list(:game, 3, :with_downloads) }
    let(:language) { create(:language, games: [games.first]) }

    it 'filters by genre' do
      genre = games.first.genre.id
      result = Game.filter(genre: genre)
      expect(result).to contain_exactly(games.first)
    end

    it 'filters by language' do
      result = Game.filter(language: language.id)
      expect(result).to contain_exactly(games.first)
    end

    it 'filters by platform' do
      games
      result = Game.filter(platform: Platform.first.id)
      manual_search = games.select do |game|
        game.platforms.include? Platform.first
      end
      expect(result).to contain_exactly(*manual_search)
    end

    it 'filters by release_type (list)' do
      games.first.update!(release_type: :demo)
      games.second.update!(release_type: :minigame)
      result = Game.filter(release_type: [Game.release_types[:demo], Game.release_types[:minigame]])
      expect(result).to contain_exactly(*games.first(2))
    end

    it 'filters by release_type' do
      games.first.update!(release_type: :demo)
      result = Game.filter(release_type: :demo)
      expect(result).to contain_exactly(games.first)
    end

    it 'filters nothing when received a wrong release_type' do
      games
      result = Game.filter(release_type: :cat)
      expect(result).to contain_exactly(*Game.all)
    end
  end
end
