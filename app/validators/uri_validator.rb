# frozen_string_literal: true
class UriValidator < ActiveModel::EachValidator
  # i18n-tasks-use t('activerecord.errors.messages.url')
  def validate_each(record, attribute, value)
    return if value.blank?
    record.errors.add(attribute, :url) unless uri?(value)
  end

  def uri?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
