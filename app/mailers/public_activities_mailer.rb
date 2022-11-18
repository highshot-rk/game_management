# frozen_string_literal: true

class PublicActivitiesMailer < ApplicationMailer
  add_template_helper(PublicActivitiesHelper)

  def notify(activity)
    I18n.locale = if activity.recipient.setting.present? && activity.recipient.setting.language.present?
                    Language.find(activity.recipient.setting.language).try(:locale)
                  else
                    :en
                  end
    @activity = activity
    mail(to: activity.recipient.email, subject: t("settings.form.mail_#{activity.key.tr('.', '_')}"))
  end
end
