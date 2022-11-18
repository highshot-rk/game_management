# frozen_string_literal: true
# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  rating     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ratings_on_game_id              (game_id)
#  index_ratings_on_user_id              (user_id)
#  index_ratings_on_user_id_and_game_id  (user_id,game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_9c1f02ed77  (game_id => games.id)
#  fk_rails_a7dfeb9f5f  (user_id => users.id)
#

require 'rails_helper'

describe Rating, type: :model do
  it 'always has a rating between 1 and 5' do
    subject.rating = nil
    expect(subject).to have(2).errors_on(:rating)
    subject.rating = ''
    expect(subject).to have(2).errors_on(:rating)
    subject.rating = 'ciao'
    expect(subject).to have(1).error_on(:rating)
    subject.rating = 6
    expect(subject).to have(1).error_on(:rating)
    subject.rating = 4.3
    expect(subject).to have(0).errors_on(:rating)
  end

  it 'updates the averange score on save' do
    game = create(:game)
    allow_any_instance_of(Rating).to receive(:execute_after_commit)
      .and_yield
    create(:rating, rating: 3, game: game)
    rating = create(:rating, rating: 5, game: game)
    rating.update(rating: 2)
    expect(game.reload.ratings_avg).to eq(2.5)
  end

  it 'updates the absolute score on save' do
    game = create(:game)
    allow_any_instance_of(Rating).to receive(:execute_after_commit)
      .and_yield
    first_rating = create(:rating, rating: 4, game: game)
    last_rating = create(:rating, rating: 1, game: game)
    expect(game.reload.ratings_abs).to eq(-1)
    last_rating.destroy
    expect(game.reload.ratings_abs).to eq(1)
    first_rating.update(rating: 5)
    expect(game.reload.ratings_abs).to eq(2)
  end
end
