# frozen_string_literal: true
class DomainValidator < ActiveModel::EachValidator
  # i18n-tasks-use t('activerecord.errors.messages.include_domain')
  # i18n-tasks-use t('activerecord.errors.messages.exclude_domain')
  def validate_each(record, attribute, value)
    return if value.blank?
    validate_inclusion!(record, attribute, value, options[:in]) if options[:in]
    validate_exclusion!(record, attribute, value, options[:exclude]) if options[:exclude]
  end

  def validate_inclusion!(record, attribute, value, hosts)
    record.errors.add(attribute, :include_domain, hosts: hosts) unless host_in_list?(value, hosts)
  end

  def validate_exclusion!(record, attribute, value, hosts)
    record.errors.add(attribute, :exclude_domain, hosts: hosts) if host_in_list?(value, hosts)
  end

  def host_in_list?(url, hosts)
    host = safe_extract_host(url)
    hosts.any? { |excluded_host| host.end_with?(excluded_host) }
  rescue URI::InvalidURIError
    true
  end

  def safe_extract_host(url)
    extract_host(url).presence || extract_host("http://#{url}").presence
  end

  def extract_host(url)
    URI.parse(url).host.to_s
  end
end
