# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'supporters/create'
  get 'supporters/update'
  delete 'supporters/destroy'

  authenticate(:user, ->(u) { u.staff? }) do
    ActiveAdmin.routes(self)
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :scores, only: :index
      resource :score, only: %i[show create]
      resource :user, only: [:show]
      resources :download_links, only: [] do
        get :counter, on: :member
      end

      resource :authentication, only: %i[create show]
    end
  end

  scope :feed do
    get '', to: 'feeds#index', as: :feed, formats: %i[html xml rss]
    scope formats: %i[xml rss] do
      get :all, to: 'feeds#all', as: :feed_all
      get :all_yandex, to: 'feeds#all_yandex', as: :feed_all_yandex
      get :popular, to: 'feeds#popular', as: :feed_popular
      get :last_updated, to: 'feeds#last_updated', as: :feed_last_updated
      get :events, to: 'feeds#events', as: :feed_events
      get 'news/:id', to: 'feeds#news', as: :news_feed
    end
  end

  if Rails.env.development?
    get('system/:filetype/files/:d1/:d2/:3/:size/file:number_name.png',
        to: redirect do
          ActionController::Base.helpers.asset_url('Images/logo.png')
        end)
  end

  get 'signature.php?gid=:id.png', to: redirect('/signature/%{id}.png'), id: /[0-9]+/

  scope '(:locale)', locale: /en|it|de|pt|fr|es|sv|id|nl|pl|ru|zh|ko|ja|uk|fi|ms|hi|sk|fa|tl|th|el/ do
    devise_for :users, controllers:  {
      sessions: 'sessions'
    }

    # concern :paginatable do
    #   get '(s/:section)(/f/:filter)(/page/:page)',
    #       page: /[0-9]+/, action: :index, on: :collection, as: ''
    # end

    %w[404 422 500].each do |code|
      get code, to: 'errors#show', code: code
    end

    scope ':id', id: /[0-9]+/ do
      get('(:slug)', to: redirect do |params, _|
        game = Game.find(params[:id])
        "/games/#{game.slug}"
      end)
      # get '(:slug)', to: 'games#show', as: :game_details
    end

    get 'signature/:id',
        to: 'games#image', as: :game_banner,
        id: /[0-9]+/, format: :png

    get 'embed/:id',
        to: 'games#embed', as: :embed_game

    delete 'score/:score_id',
           to: 'games#destroy_score', as: :destroy_score

    get 'comments/:id(/page/:page)',
        to: 'comments#answers', as: :comment_answers,
        page: /[0-9]+/

    resource :language, only: %i[edit update]

    %i[news downloaded chart].each do |section|
      get "#{section}(/:filter)(/page/:page)",
          to: "games_sections\##{section}", page: /[0-9]+/,
          as: "#{section}_games"
    end

    # get 'popular(/:platform)(/page/:page)',
    #     to: 'games#popular',
    #     page: /[0-9]+/, as: :popular_games

    resources :games, except: [:index] do
      member do
        get :indiepad, formats: [:json]
        get :stats
        get :card
        get :embed_popup
        get :share
        get :record_info
        get :record_chart
        get :rating_filters
        get :players_list
        get :followers_list
        get :monetisation
        get :support
      end
      collection do
        get :qrcode
      end
      resource :news, only: %i[create destroy]
      get :news, to: 'news#index'
      resource :comments, only: %i[create destroy]
      get :comments, to: 'comments#index'
      resource :followings, only: %i[update destroy]
      resource :ratings, only: [:update]
      resources :monetisations, only: %i[create update]
    end

    resources :download_links, only: [] do
      resources :reports, only: %i[new create]
    end

    get 'download/:id', to: 'download_links#proxy', as: :download_link
    get 'play/:id', to: 'download_links#play', as: :play_link
    get 'search(/page/:page)', to: 'search#games', page: /[0-9]+/,
                               as: :search

    authenticated do
      scope :users do
        resources :options, as: :user_options, only: [:index]
        resources :levels, as: :user_levels, only: [:index]
        get :games, to: 'me#games', as: :user_games
        get :subscriptions, to: 'me#followed_games', as: :user_followed_games
        get :events, to: 'me#event_subscriptions', as: :user_event_subscriptions
        scope :settings do
          get :edit, to: 'settings#edit', as: :edit_user_settings
          put '', to: 'settings#update', as: :user_settings
        end
      end
    end
    resources :users, only: :show

    scope :notifications do
      get '', to: 'public_activities#index', as: :notifications
      get 'load_more', to: 'public_activities#show', as: :notifications_load_more, formats: [:js]
      delete ':id', to: 'public_activities#destroy', as: :notification

      get 'count', to: 'notifications#index', as: :notifications_count
      get 'read_all', to: 'notifications#read_all', as: :read_all_notifications
    end

    resources :events do
      member do
        get :share
      end
      resource :subscription, only: %i[update destroy]
    end

    get 'license', to: 'static#license', as: :license
    get 'manifest', to: 'static#manifest', as: :manifest
    get 'faq', to: 'static#faq', as: :faq
    get 'developers', to: 'static#developers', as: :developers
    get 'sitemap', to: 'sitemaps#index'
    get 'sitemap_games_:page', to: 'sitemaps#games', page: /[0-9]+/, as: :games_sitemap, formats: [:xml]
    get 'sitemap_events_:page', to: 'sitemaps#events', page: /[0-9]+/, as: :events_sitemap, formats: [:xml]
    get 'sitemap_users_:page', to: 'sitemaps#users', page: /[0-9]+/, as: :users_sitemap, formats: [:xml]
    get 'sitemap_pages', to: 'sitemaps#pages', as: :pages_sitemap, formats: [:xml]
    get 'about', to: 'static#about'
    get 'warning', to: 'warning#index', as: :warning

    get 'arcade', to: 'home#arcade', as: :arcade_games
    get 'indiepad', to: 'home#indiepad', as: :indiepad_games
    get 'subscriptions', to: 'home#subscriptions', as: :subscribed_games
    get 'your_games', to: 'home#your_games', as: :your_games
    get 'history', to: 'home#history', as: :history_games

    root to: 'home#landing'
  end
end
