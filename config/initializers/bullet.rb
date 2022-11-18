Rails.application.config.after_initialize do
  unless Rails.env.production?
    Bullet.enable = true
    Bullet.bullet_logger = true

    # Enable bullet javascript alert pop-ups in development only
    Bullet.alert = Rails.env.development?
    # Raise errors in test instead
    # Bullet.raise = Rails.env.test?
  end
end
