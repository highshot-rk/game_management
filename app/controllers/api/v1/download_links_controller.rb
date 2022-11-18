# frozen_string_literal: true

class Api::V1::DownloadLinksController < Api::V1::ApiController

  # We don't need to authenticate users against this route as we need it to
  # retrieve the value for visitors as well.
  #
  skip_before_action :authorize_code!

  def counter
    response = {
      status: 200,
      downloads: download_link.game.downloads_count
    }

    # I don't see this ever failing, so we're not going to try and rescue
    # or handle any errors.
    # REVIEW: If it ever fails, let's rescue
    #
    respond_to do |format|
      format.js { render(json: response) }
      format.json { render(json: response) }
    end
  end

private

  def download_link
    @download_link ||= DownloadLink.find(params[:id])
  end
end
