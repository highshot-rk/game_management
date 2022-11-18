class DownloadsService < BaseService
  class CreateError < BaseService::Error; end

  include ScoreAssigner
  score :download

  def create(download_link)
    if params[:user]
      create_for_member(download_link)
    else
      create_for_visitor(download_link)
    end
  rescue ActiveRecord::RecordNotUnique
    raise CreateError
  end

  def create_for_visitor(download_link)
    fail CreateError unless download_link.downloads.create(params)
  end

  def create_for_member(download_link)
    @download = download_link.downloads.find_or_initialize_by(params)
    return unless @download.new_record?
    fail CreateError unless @download.save
    assign_score @download.user, :create
  end
end
