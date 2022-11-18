# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'API::V1::AuthenticationController', type: :request do
  describe 'GET /api/auth' do
    let!(:user) { sign_up }
    it 'gets the authentication token' do
      get api_v1_authentication_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(user.reload.token)
    end
  end

  describe 'POST /api/auth' do
    let(:game) { create(:game, token: '123123') }
    let(:user) { create(:user, token: '123123123') }
    it 'creates a new authentication token' do
      post api_v1_authentication_path(game_key: game.token, user_token: user.token)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to include('access_token')
    end
  end

  describe 'POST /api/auth' do
    let(:game) { create(:game, token: '123123') }
    let(:user) { create(:user, token: '123123123') }
    it 'creates a new authentication token' do
      post api_v1_authentication_path(game_key: game.token, user_token: user.token)
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to include('access_token')
    end
  end
end
