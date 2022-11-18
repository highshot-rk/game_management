# frozen_string_literal: true
class GamesController < ApplicationController
  include CommentsUserDetailsLoader
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :rating_filters, :followers_list]

  before_action :check_authorization!, only: [:edit, :stats, :update, :destroy, :players_list, :record_info, :monetisation]
  include SuggestionsProvider
  suggestions on: [:show, :stats], includes: [:screen]

  before_action :load_game!, only: [:show, :stats]

  respond_to :html

  # https://github.com/equivalent/scrapbook2/blob/master/archive/blogs/2014-03-render-images-with-rails-controller.md
  def image
    expires_in 10.minutes, public: true
    generator = ImageBuilder::SignatureGenerator.new(game)
    file = generator.generate
    send_file file, type: 'image/png', disposition: 'inline'
  end

  def embed
    @game = Game.find(params[:id]).decorate
    @game.play_online || fail(ActiveRecord::RecordNotFound)
    render layout: 'embed'
    response.headers.except! 'X-Frame-Options'
  end

  def embed_popup
    @game = Game.find(params[:id]).decorate
    render layout: nil
  end

  def record_chart
    @game = Game.find(params[:id])
    @scores = @game.scores.where(name: params[:name])
                   .order(value: :desc).order(updated_at: :asc)
                   .page(params[:page]).per(20)

    render layout: nil
  end

  def rating_filters
    @game = Game.find(params[:id]).decorate
    render layout: nil
  end

  def followers_list
    @game = Game.find(params[:id])
    @followings = @game.followings
                   .order(created_at: :desc)
                   .page(params[:page]).per(20)

    render layout: nil
  end

  def players_list
    @game = Game.find(params[:id])
    @players = @game.downloads.select('downloads.*')
                .where('downloads.created_at >= ?', 7.days.ago)
                .order('downloads.created_at DESC')

    render layout: nil
  end

  def destroy_score
    @score = Score.find(params[:score_id])
    @score.destroy
    redirect_back fallback_location: root_path
  end

  def record_info
    @game = Game.find(params[:id]).decorate
    render layout: nil
  end

  def share
    @game = Game.find(params[:id]).decorate
    render layout: nil
  end

  def monetisation
    @game = Game.find(params[:id]).decorate
    @supporter_requests = Supporter.where(game_id: @game.id).where(confirmed: false)
    render layout: nil
  end

  def support
    @game = Game.find(params[:id]).decorate
    render layout: nil
  end

  def card
    @user = User.find_by!('lower(username) = lower(?)', params[:id])
    render layout: nil
  end

  def qrcode
    render layout: nil
  end

  def indiepad
    @game = Game.find(params[:id])
    @indiepad_config = @game.indiepad_config || IndiepadConfig.new
    render 'indiepad_configs/data'
  end

  def create
    run :create, create_params
    redirect_to game_url(@service.output.slug)
  rescue GamesService::CreateError
    @game = touch_game @service.output
    render :new
  end

  def new
    @game = touch_game Game.new
  end

  def edit
    @game = touch_game(Game.includes(screens: :game, artworks: :game).find(params[:id]))
  end

  def show
    register_visit! @game
    load_comments!
    load_stats!
    load_api!
    MedalsManager.new(game).refresh_medals
    render layout: pjax_request? ? nil : 'game'
  end

  def stats
    load_stats!
    render layout: pjax_request? ? nil : 'game'
  end

  def update
    run :update, update_params, params[:id]
    redirect_to game_url(@service.output.slug)
  rescue GamesService::UpdateError
    @game = touch_game(@service.output)
    render :edit
  end

  def destroy
    run :destroy, params
    flash[:notice] = t('.destroyed')
    redirect_to root_path
  rescue GamesService::DestroyError
    @game = touch_game(@service.output)
    render :edit
  end

  private

  def load_api!
    return if !current_user || !game.token
    @auth_code = AuthCode.valid.where(game: game, user: current_user).first_or_create
  end

  def load_game!
    @game = Game.includes(downloadable_links: :platforms).find(params[:id]).decorate
    redirect_to(game_path(@game.slug, locale: params[:locale]), status: :moved_permanently) if params[:id] != @game.slug
  end

  def register_visit!(game)
    game.visits.create(user: current_user)
  end

  def last_user_comment
    current_user.comments
                .order(created_at: :asc)
                .where(game: @game)
                .last if current_user && (current_user.username != @game.author)
  end

  def load_comments!
    base = @game.comments.roots.includes(:user).latest
    if luc = last_user_comment
      @comments = [luc] + base.where.not(id: luc.id).limit(2).to_a
    else
      @comments = base.limit(3)
    end
  end

  def load_stats!
    @stats = StatsCalculator.new(game) if policy(game).update?
  end

  def setup_params!
    @params = params.except(:controller, :action, :locale)
  end

  def touch_game(game)
    game.setup_with_relations(
      user: current_user,
      relations: {
        videos: 1,
        screens: 3,
        artworks: 3
      }
    )
  end

  def check_authorization!
    authorize game
  end

  def create_params
    update_params.merge(user: current_user)
  end

  def update_params
    params.require(:game).permit(
      :title, :description, :long_description, :author, :release_type, :genre, :genre_id, :adult_content,
      :tool_id, :website, :indiepad, :mobile_first,
      videos_attributes: [:id, :url, :_destroy], language_ids: [],
      download_links_attributes: [:file, :url, :id,
                                  :_destroy, platform_ids: []],
      screens_attributes: [:file, :_destroy, :id],
      artworks_attributes: [:file, :_destroy, :id],
      indiepad_config_attributes: [data: [Settings.indiepad.keycodes.keys]]
    )
  end

  def game
    @game ||= Game.find(params[:id]).decorate
  end

  def setup_sections
    @section = params[:action]
  end
end
