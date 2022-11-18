# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  legacy_password        :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  staff                  :boolean          default(FALSE), not null
#  notifications_count    :integer          default(0), not null
#  score                  :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  token                  :string
#  verified               :boolean          default(FALSE)
#  banned_at              :datetime
#  first_name             :string
#  surname                :string
#  phone_number           :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

require 'rails_helper'

describe User, type: :model do
  # always_has_a :username
  always_has_unique :username

  always_has_unique :email

  describe '#authored_games' do
    let(:user) { create(:user) }
    let(:game1) { create(:game, user: user, author: user.username) }
    let(:game2) { create(:game, user: user) }
    let(:game3) { create(:game, author: user.username) }
    it 'finds games by author' do
      expect(user.authored_games).to contain_exactly(game1, game3)
    end
  end

  describe '#map_game_ids' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:game1) { create(:game, user: user1) }
    let!(:game2) { create(:game, user: user2) }
    let!(:game3) { create(:game, author: user1.username) }
    let!(:game4) { create(:game, author: user2.username) }
    let!(:game5) { create(:game, author: user2.username) }
    let!(:game6) { create(:game, author: user1.username) }

    it 'lists authored_games by user id' do
      user_games_map = User.map_game_ids.to_h
      expect(user_games_map.keys).to contain_exactly(user1.id, user2.id)
      expect(user_games_map[user1.id]).to contain_exactly(game3.id, game6.id)
      expect(user_games_map[user2.id]).to contain_exactly(game4.id, game5.id)
    end
  end

  describe '#current_settings' do
    it 'gets initialized if does not exist' do
      expect(subject.current_settings).to be_new_record
    end

    it 'otherwise gets the stored value' do
      user = create(:user)
      user.current_settings.save!
      expect(user.reload.current_settings).not_to be_new_record
    end
  end

  describe '#level' do
    it 'returns the correct level' do
      subject.score = 0
      expect(subject.level).to eq(0)
      subject.score = -1
      expect(subject.level).to eq(0)
      subject.score = Settings.levels[1]
      expect(subject.level).to eq(2)
      subject.score = Settings.levels[4]
      expect(subject.level).to eq(5)
    end
  end

  # it 'validates username with regexp' do
  #   subject.username = 'the cat'
  #   expect(subject).to have(1).error_on(:username)
  #   subject.username = 'the@cat'
  #   expect(subject).to have(1).error_on(:username)
  #   subject.username = '#thecat'
  #   expect(subject).to have(1).error_on(:username)
  #   subject.username = 'the_cat-01'
  #   expect(subject).to have(0).errors_on(:username)
  # end

  describe '#followers' do
    it 'shows all users following my games' do
      followers = create_list(:user, 2)
      user = create(:user)
      games = create_list(:game, 2, user: user)
      create(:following, user: followers.first, game: games.first)
      create(:following, user: followers.first, game: games.last)
      create(:following, user: followers.last, game: games.last)
      create(:following, user: followers.last, game: games.first)
      expect(user.followers).to contain_exactly(*followers)
      expect(user.followers.count).to eq(2)
    end
  end

  describe "banned?" do
    subject { user.banned? }

    let(:user) { build(:user) }

    it { is_expected.to be false }

    context "when user is banned" do
      let(:user) { build(:user, banned_at: 2.days.ago) }

      it { is_expected.to be true }
    end
  end
end
