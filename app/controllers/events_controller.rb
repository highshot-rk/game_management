class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_authorization, only: [:update, :destroy]
  before_action :setup_filters!, only: :index
  before_action :score_games, only: :index
  before_action :best_players, only: :index

  def index
    @events = filter_by_type(Event.active(!@passed))
              .order(start: :asc)
              .page(params[:page]).decorate
  end

  def show
    load_event!
  end

  def share
    @event = Event.find(params[:id]).decorate
    render layout: nil
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    authorize Event
    run :create, create_params
    redirect_to event_path(@service.output.slug)
  rescue EventsService::CreateError
    @event = @service.output
    render :new
  end

  def edit
    event
  end

  def update
    run :update, update_params, event
    redirect_to event_path(@service.output.slug)
  rescue EventsService::UpdateError
    render :edit
  end

  def destroy
    run :destroy, {}, event
    redirect_to events_path
  rescue EventsService::DestroyError
    render :edit
  end

  private

  def load_event!
    @event = Event.includes(:languages).find(params[:id]).decorate
    redirect_to(
      event_path(@event.slug, locale: params[:locale]), status: :moved_permanently
    ) if params[:id] != @event.slug
  end

  def filter_by_type(query)
    if @event_type.present?
      query.where(event_type: @event_type)
    else
      query
    end
  end

  def setup_filters!
    @params = params.permit(:event_type, :passed)
    # @params = params.except(:controller, :action, :locale)
    @passed = params[:passed]
    @event_type = params[:event_type]
  end

  def check_authorization
    authorize event
  end

  def create_params
    update_params.merge(user: current_user)
  end

  def update_params
    params.require(:event)
          .permit(:title, :description, :prizes, :rules,
                  :start_date, :end_date, :website,
                  :event_type, :screen, language_ids: [])
  end

  def event
    @event ||= Event.find(params[:id]).decorate
  end

  def score_games
    @games = Game.having_scores.limit(12).decorate
  end

  def best_players
    @best_players = Game.best_players.limit(6).decorate
  end
end