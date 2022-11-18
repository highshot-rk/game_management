# frozen_string_literal: true

module ErrorsLogger
  extend ActiveSupport::Concern

  included do
    before_action :set_raven_context

    rescue_from Pundit::NotAuthorizedError do
      render 'errors/401.html', status: 401
    end
    if Rails.env.production?
      rescue_from ActionView::MissingTemplate do |e|
        Raven.capture_exception(e) if defined?(Raven)
        render 'errors/404.html', status: 404
      end
    end
  end

  private

  def set_raven_context
    return unless defined?(Raven)
    Raven.user_context(id: current_user&.id) if current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
