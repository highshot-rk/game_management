class ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report = Report.new(download_link: download_link)
    render layout: false
  end

  def create
    run :create, create_params
  rescue ReportsService::CreateError
    @errors = @service.output.errors.full_messages.to_sentence
    render 'error', format: :js
  end

  private

  def create_params
    params.require(:report).permit(:type, :message)
          .merge(user: current_user, download_link: download_link)
  end

  def download_link
    @download_link ||= DownloadLink.find params[:download_link_id]
  end
end
