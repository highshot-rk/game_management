# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Reports, type: :mailer do
  let!(:staff) { create(:user, staff: true) }
  let!(:report) { create(:report) }

  it 'send a notification to admin about a report' do
    mail = described_class.notify_staff(staff.email, report.id)
    expect(mail.to).to eq([staff.email])
    expect(mail.body.encoded).to include(admin_report_url(report.id))
  end
end
