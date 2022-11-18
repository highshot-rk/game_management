class EventsService < BaseService
  class CreateError < BaseService::Error; end
  class UpdateError < BaseService::Error; end
  class DestroyError < BaseService::Error; end

  def create
    @event = Event.new(params)
    fail CreateError unless @event.save
  end

  def update(id)
    @event = find_event(id)
    fail UpdateError unless @event.update(params)
  end

  def destroy(id)
    @event = find_event(id)
    fail DestroyError unless @event.destroy
  end

  def output
    @event
  end

  private

  def find_event(event)
    event.is_a?(Event) ? event : Event.find(event)
  end
end
