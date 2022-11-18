class ReportsService < BaseService
  class CreateError < BaseService::Error; end

  def create
    @report = Report.new(params)
    fail CreateError unless @report.save
    User.staff.find_each do |staff|
      Reports.notify_staff(staff.email, @report).deliver_later
    end
  end
end
