class GamesService < BaseService
  class CreateError < BaseService::Error; end
  class UpdateError < BaseService::Error; end
  class DestroyError < BaseService::Error; end
  include ScoreAssigner
  include NotificationSender
  score :game

  def create
    @game = Game.new(parsed_parameters)

    fail CreateError unless @game.save
    after_create @game
  end

  def update(id)
    @game = Game.find(id)
    fail UpdateError unless @game.update(parsed_parameters)
    notify_staff @game, 'update'
  end

  def destroy
    @game = Game.find(params[:id])
    fail DestroyError unless @game.destroy
    assign_score @game.user, :destroy
    # TODO: Send destroy game notification
    # notify_staff @game, 'destroy'
  end

  def output
    @game
  end

  private

  def parsed_parameters
    if params[:indiepad_config_attributes] && params[:indiepad_config_attributes][:data].respond_to?(:keys)
      params[:indiepad_config_attributes][:data] = params[:indiepad_config_attributes][:data].to_h.map { |_, v| v }
    end
    params
  end

  def after_create(game)
    notify_followers game
    notify_staff game, 'create'
    assign_score(game.user, :create)
  end

  def notify_followers(game)
    notify! game, 'create', from: game.user, to: game.user.followers.where.not(id: game.user.id).distinct.to_a, scope: :follower
  end

  def notify_staff(game, reason)
    notify! game, reason, from: game.user, to: User.staff.to_a, scope: :staff
  end
end
