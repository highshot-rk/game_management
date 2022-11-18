# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Navigator', type: :request do
  before(:all) do
    @user = create(:user)
    @game = create(:game, :with_play_online, :with_resources, :with_scores, :with_news, :with_comments)
    @event = create(:event)
    @news = create(:news)
    @comment = create(:comment)
    @download_link = create(:download_url)
  end

  let(:game) { @game }
  let(:user) { @user }
  let(:event) { @event }
  let(:news) { @news }
  let(:comment) { @comment }
  let(:download_link) { @download_link }

  describe 'checks all routes' do
    Rails.application.routes.routes.to_a.each do |e|
      next unless e.name
      next unless e.send(:verbs).include?('GET')
      next if e.name.include?('admin_')
      next if e.name.include?('api_')
      next if e.name.include?('supporter')

      it e.name do
        begin
          sign_up.update(staff: true)
          route = build_route(e)
          request_format = e.required_defaults[:formats]&.first
          if request_format.in?([:js, :json])
            get route, params: { format: request_format }, xhr: true
          elsif request_format
            get route, params: { format: request_format }
          else
            get route
          end
        rescue ActionController::UnknownFormat
          skip 'Unknown format'
        end
      end
    end
  end

  def build_route(route)
    params = {}
    route.required_keys.each do |key|
      next if key.in?([:controller, :action])
      params[key] = if key == :id
                      id_from_route(route)
                    elsif key == :page
                      1
                    else
                      id_from_key(key.to_s)
                    end
    end
    public_send("#{route.name}_path", params)
  end

  def id_from_route(route)
    id_from_key(route.name)
  end

  def id_from_key(key)
    if key.include?('event')
      event.id
    elsif key.include?('user')
      user.username
    elsif key.include?('game') || key == 'news_feed'
      game.id
    elsif key.include?('comment')
      comment.id
    elsif key.include?('news')
      news.id
    elsif key.include?('download_link') || key.include?('play_')
      download_link.id
    end
  end
end
