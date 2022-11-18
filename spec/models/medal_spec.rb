# frozen_string_literal: true
# == Schema Information
#
# Table name: medals
#
#  id         :integer          not null, primary key
#  key        :string
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#  game_id    :integer
#  user_id    :integer
#  descending :boolean          default(FALSE), not null
#  story      :text             default([]), not null, is an Array
#
# Indexes
#
#  index_medals_on_game_id                      (game_id)
#  index_medals_on_key                          (key)
#  index_medals_on_key_and_game_id_and_user_id  (key,game_id,user_id) UNIQUE
#  index_medals_on_user_id                      (user_id)
#

require 'rails_helper'

describe Medal, type: :model do
  always_has_a :key
  always_has_a :score

  it 'validates a game or an user' do
    expect(subject).to have(1).error_on(:user_or_game)
    subject.game = Game.new
    expect(subject).to have(0).error_on(:user_or_game)
    subject.game = nil
    subject.user = User.new
    expect(subject).to have(0).error_on(:user_or_game)
  end

  describe '#improved?' do
    it 'is true when the score is increased and descending is false' do
      medal = create(:medal, score: 10)
      expect(medal).not_to be_improved
      medal.score = 100
      expect(medal).to be_improved
      medal.score = 1
      expect(medal).not_to be_improved
    end

    it 'is true when the score is increased and descending is false' do
      medal = create(:medal, score: 10, descending: true)
      expect(medal).not_to be_improved
      medal.score = 1
      expect(medal).to be_improved
      medal.score = 100
      expect(medal).not_to be_improved
    end
  end

  it 'stores the story' do
    medal = create(:medal, score: 1)
    expect(medal.story).to be_empty
    expect(medal).not_to be_already_assigned
    medal.update(score: 100)
    expect(medal).not_to be_already_assigned
    medal.story.map!(&:to_i)
    expect(medal.story).to include(1)
    medal.update(score: 1)
    expect(medal).to be_already_assigned
    medal.story.map!(&:to_i)
    expect(medal.story).to include(1, 100)
  end
end
