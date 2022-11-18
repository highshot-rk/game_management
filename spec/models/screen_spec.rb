# frozen_string_literal: true
# == Schema Information
#
# Table name: resources
#
#  id                :integer          not null, primary key
#  type              :string           not null
#  url               :text
#  game_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_processing   :boolean
#
# Indexes
#
#  index_resources_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_a9b6901174  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe Screen, type: :model do
  it 'shows the original file when it\'s still processing' do
    screen = create(:screen, file_processing: true)
    expect(screen.file.url(:medium)).to include('/original/')
    screen.file_processing = false
    expect(screen.file.url(:medium)).to include('/medium/')
  end

  it 'updates game #screen column on save and on destroy' do
    game = create(:game)
    screen = build(:screen, game: game)
    expect do
      screen.save
    end.to change(game.reload, :screen).from(nil).to(screen)

    expect do
      create(:screen, game: game)
    end.not_to change(game.reload, :screen)

    expect do
      screen.destroy
    end.to change(game.reload, :screen).to(game.screens.last)
  end

  it 'updates game #screen column on save when db is incoherent' do
    game = create(:game, screen_id: 12_341)
    screen = build(:screen, game: game)
    expect do
      screen.save
    end.to change(game.reload, :screen).from(nil).to(screen)
  end
end
