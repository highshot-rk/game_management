module UrlOrFile
  extend ActiveSupport::Concern

  included do
    validate :url_or_file?
  end

  def url_or_file?
    errors.add(
      :base, 'Add at least an url or a file'
    ) if file_url.blank?
  end

  def file_url
    file_file_name ? file.url : url
  end
end
