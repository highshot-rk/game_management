module AliasDateAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    def alias_date_attribute_with_format(attribute, time_format, suffix: nil)
      define_method("#{attribute}_#{suffix}") do
        (public_send(attribute) || Time.zone.now).strftime(time_format)
      end

      define_method("#{attribute}_#{suffix}=") do |time|
        self[attribute] = time.to_time.try(:in_time_zone)
      end
    end
  end
end
