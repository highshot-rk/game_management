# frozen_string_literal: true

class Html5GamePrepare < ApplicationJob
  queue_as :default

  rescue_from ActiveRecord::RecordNotFound do
  end

  def perform(download_link_id)
    download = DownloadLink.find(download_link_id)
    return if download.play_online?

    file_name = extract_play_online(download)
    inject_indiepad(download) if file_name && file_name.ends_with?('index.html')

    return false unless file_name

    download.update!(play_online: true, play_online_name: file_name)
  end

  private

  def inject_indiepad(download)
    indiepad = IndiepadInjector.new("#{Rails.root}/public/html5/#{download.id}/index.html")
    indiepad.inject!
  end

  def extract_play_online(download)
    [:find_swf, :find_and_extract_html, :find_and_extract_swf].each do |method|
      file_name = __send__(method, download)
      return file_name if file_name
    end
    false
  end

  def find_swf(download)
    return unless download.file.path =~ /\A.*\.swf\Z/
    FileUtils.mkdir_p "#{Rails.root}/public/html5/#{download.id}"
    FileUtils.cp download.file.path, "#{Rails.root}/public/html5/#{download.id}/index.swf"
    'index.swf'
  end

  def find_and_extract_swf(download)
    find_file_in_archive download, %r{\A[^/]+\.swf\Z}
  end

  def find_and_extract_html(download)
    find_file_in_archive(download, 'index.html')
  end

  def find_file_in_archive(download, file_to_find)
    extractor = ZipResourcesExtractor.new(download.file.path, file_to_find)
    return false if download.file.path.ends_with?('.apk')
    return false unless extractor.contains_file?
    extractor.extract!("#{Rails.root}/public/html5/#{download.id}")
  end
end
