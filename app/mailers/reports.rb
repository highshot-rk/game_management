# frozen_string_literal: true
class Reports < ApplicationMailer
  def notify_staff(staff_email, report_id)
    @report = Report.find(report_id)
    mail(to: staff_email, subject: "New report from #{@report.user.username}")
  end
end
