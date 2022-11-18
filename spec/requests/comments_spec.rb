# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_comments_on_game_id  (game_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_8bbcb19e0f  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:game) { create(:game) }
  let!(:comments) { create_list(:comment, 3, :with_answers, game: game) }

  describe 'GET /comments' do
    it 'lists parent comments' do
      get game_comments_path(game_id: game.slug)
      expect(response).to have_http_status(200)
      comments.each do |comment|
        expect(response.body).to include("id=\"comment:#{comment.id}\"")
      end
    end
  end

  describe 'GET /answers' do
    it 'lists all comment answers' do
      get comment_answers_path(id: comments.first.id)
      expect(response).to have_http_status(200)
      comments.first.children.each do |comment|
        expect(response.body).to include("id=\"comment:#{comment.id}\"")
      end
    end
  end

  describe 'GET /answers' do
    it 'lists all comment answers' do
      get comment_answers_path(id: comments.first.id)
      expect(response).to have_http_status(200)
      comments.first.children.each do |comment|
        expect(response.body).to include("id=\"comment:#{comment.id}\"")
      end
    end
  end

  describe 'POST /comments' do
    it 'fails when you\'re not logged in' do
      post game_comments_path(game_id: game), params: { comment: { text: 'ciao' } }
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'creates a new comment' do
      sign_up
      expect do
        post game_comments_path(game_id: game), params: { comment: { text: 'ciao' } }
        expect(response).to have_http_status(201)
      end.to change(Comment, :count).by(1)
    end

    it 'notifies followers when a comment is created' do
      sign_up
      follower = create(:following, game: game).user
      expect do
        expect do
          post game_comments_path(game_id: game),
               params: { comment: { text: 'ciao' } }
          expect(response).to have_http_status(201)
        end.to change(Comment, :count).by(1)
      end.to change(PublicActivity::Activity.where(recipient: follower), :count)
    end

    it 'creates a new answer' do
      sign_up
      expect do
        post game_comments_path(game_id: game),
             params: { comment: { text: 'ciao', comment_id: comments.first.id } }
        expect(response).to have_http_status(201)
      end.to change(comments.first.children.reload, :count).by(1)
    end

    it 'creates nothing if there\'s no text' do
      sign_up
      expect do
        post game_comments_path(game_id: game), params: { comment: { text: '' } }
        expect(response).to have_http_status(302)
        expect(flash[:error]).not_to be_nil
      end.not_to change(Comment, :count)
    end
  end
end
