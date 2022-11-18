class DownloadLinksController < ApplicationController
  def proxy
    update_download_count!
    if download_link.url.present?
      redirect_to validate_link(download_link.url)
    else
      redirect_to download_link.file.url
    end
  end

  def play
    if download_link.play_online?
      update_download_count!
      file_name = download_link.play_online_name || 'index.html'
      if valid_request
        redirect_to "#{ENV['ASSET_URL']}/html5/#{download_link.id}/#{file_name}"
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  private

  def validate_link(link)
    if link.starts_with?('Games/') || link.starts_with?('games/')
      "/#{link}"
    elsif [URI::HTTP, URI::HTTPS, URI::FTP].include? URI(link).class
      link
    else
      "http://#{link}"
    end
  rescue URI::InvalidURIError
    "http://#{link}"
  end

  def update_download_count!
    unless download_recorded?

      # Increments the counter if the user is not logged in. Uses the user session to store
      # a boolean for the specific download_link through its id.
      #
      # REVIEW: Clever, but not bulletproof. Find a better, proper way, of checking downloads
      # for non-authenticated users.
      # Look into Current.download and session details!
      #
      session["downloaded_#{ download_link.id }"] = true

      service = DownloadsService.new(user: current_user, ip: request.remote_ip)
      service.create(download_link)
    end
  rescue DownloadsService::CreateError
    nil
  end

  def download_recorded?

    # @pacMakaveli: Added a better way of checking if an authenticate User downloaded
    # the file or not.
    # Session values are not reliable. Instead, we'll check if the DownloadLink
    # has a downloads record for the current_user.
    #
    # For non-authenticated users, we'll still check the session
    #
    if current_user
      return download_link.downloads.where(user: current_user).any?
    else
      return session["downloaded_#{ download_link.id }"].present?
    end
  end

  def download_link
    @download_link ||= DownloadLink.find(params[:id])
  end

  def valid_request
    #use ENV["SITE_URL"] for host name
    response.request.env["HTTP_REFERER"].match(/^https:\/\/www.indiexpo.net\//).present?
  end
end
