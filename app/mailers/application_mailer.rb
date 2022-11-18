# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: Devise.mailer_sender
  layout 'mailer'
end
