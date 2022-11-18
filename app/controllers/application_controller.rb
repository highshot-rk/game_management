class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit
  include ErrorsLogger
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_csrf_missing!

  around_action :skip_bullet!

  protected

  def skip_bullet!
    Bullet.enable = false if defined?(Bullet) && params[:format] == 'amp'
    yield
  ensure
    Bullet.enable = true if defined?(Bullet)
  end

  def append_info_to_payload(payload)
    super
    payload[:username] = current_user.try(:username)
    payload[:ip] = request.remote_ip
  end

  def handle_csrf_missing!
    render 'errors/csrf', status: :unprocessable_entity
  end

  def after_sign_in_path_for(resource_or_scope)
    from_parameter || signed_in_root_path(resource_or_scope)
  end

  def from_parameter
    URI(params[:from]).path if params[:from].present?
  end

  def run(action, params, *args)
    @service = service_name.new(params)
    @service.__send__(action, *args)
  end

  def service_name
    class_name = self.class.name
    class_name[/Controller$/] = ''
    class_name = class_name.split('::').last
    "#{class_name}Service".constantize
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :terms_of_service])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username_or_email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def set_locale
    I18n.locale = if user_signed_in? && current_user.setting.present? && current_user.setting.language.present?
                    user_locale
                  else
                    current_locale
                  end
  end

  def current_locale
    params[:locale] || extract_locale_from_accept_language_header ||
      I18n.default_locale
  end

  def user_locale
    Language.find(current_user.setting.language).try(:locale)
  end

  def extract_locale_from_accept_language_header
    http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def default_url_options(options = {})
    if user_signed_in? && current_user.setting.present?
      if current_user.setting.language.present?
        { locale: user_locale }.merge options
      else
        { locale: I18n.locale }.merge options
      end
    else
      { locale: I18n.locale }.merge options
    end
  end

  after_action :user_activity

  private

  def user_activity
    current_user.try :touch
  end
end
