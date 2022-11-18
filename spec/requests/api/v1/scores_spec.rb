# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'API::ScoresController', type: :request do
  let(:game) { create(:game) }
  let(:auth_code) { create(:auth_code) }

  describe 'GET /api/scores' do
    it 'gets all scores for the current game' do
      create_list(:score, 10, game: auth_code.game).each { |e| e.update(value: rand(100)) }
      get api_v1_scores_path, headers: { 'Authentication' => "bearer #{auth_code.token}" }
      expect(response).to have_http_status(200)
      expect(response.json['scores'].count).to eq(10)
    end
  end

  describe 'GET /api/score' do
    it 'gets my score for the current game' do
      create(:score, user: auth_code.user, game: auth_code.game, value: 10)
      get api_v1_score_path, headers: { 'Authentication' => "bearer #{auth_code.token}" }
      expect(response).to have_http_status(200)
      expect(response.json['score']).to eq(10)
    end

    it 'gets my default score for the current game' do
      get api_v1_score_path, headers: { 'Authentication' => "bearer #{auth_code.token}" }
      expect(response).to have_http_status(200)
      expect(response.json).to eq('score' => 0, 'achieved_at' => Date.new(0).to_s)
    end
  end

  describe 'POST /api/scores' do
    it 'sets a certain score' do
      post api_v1_score_path, headers: { 'Authentication' => "bearer #{auth_code.token}" }, params: { score: 10 }
      expect(response).to have_http_status(200)
      expect(response.json).to eq('success' => true)
    end

    it 'could not set a negative score' do
      post api_v1_score_path, headers: { 'Authentication' => "bearer #{auth_code.token}" }, params: { score: -10 }
      expect(response).to have_http_status(200)
      expect(response.json).to eq('success' => false)
    end
  end
end
