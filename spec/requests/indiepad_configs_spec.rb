# frozen_string_literal: true
# == Schema Information
#
# Table name: indiepad_configs
#
#  id      :integer          not null, primary key
#  data    :json             not null
#  game_id :integer          not null
#
# Indexes
#
#  index_indiepad_configs_on_game_id  (game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_de8e6fcffa  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe 'Indiepad Config', type: :request do
  describe 'GET /games/:id/indiepad_config' do
    let(:game) { create(:game) }

    it 'returns the actial config' do
      IndiepadConfig.create!(
        game: game,
        data: [
          {
            left: :a,
            up: :w,
            right: :d,
            down: :s,
            z: :o,
            x: :p,
            escape: :l
          },
          {
            left: :left,
            up: :up,
            right: :right,
            down: :down,
            z: :z,
            x: :x,
            escape: :escape
          }
        ]
      )
      get indiepad_game_path(id: game.id), as: :json
      expect(response).to have_http_status 200
      expect(JSON.parse(response.body)).to eq(
        'keys' => {
          '0' => [
            [65, 'KeyA'],
            [87, 'KeyW'],
            [68, 'KeyD'],
            [83, 'KeyS'],
            [79, 'KeyO'],
            [80, 'KeyP'],
            [76, 'KeyL']
          ],
          '1' => [
            [37, 'ArrowLeft'],
            [38, 'ArrowUp'],
            [39, 'ArrowRight'],
            [40, 'ArrowDown'],
            [90, 'KeyZ'],
            [88, 'KeyX'],
            [27, 'Escape']
          ]
        }
      )
    end

    it 'returns the default config' do
      get indiepad_game_path(id: game.id), as: :json
      expect(response).to have_http_status 200
      expect(JSON.parse(response.body)).to eq(
        'keys' => {
          '0' => [
            [37, 'ArrowLeft'],
            [38, 'ArrowUp'],
            [39, 'ArrowRight'],
            [40, 'ArrowDown'],
            [90, 'KeyZ'],
            [88, 'KeyX'],
            [27, 'Escape']
          ]
        }
      )
    end
  end
end
