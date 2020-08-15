
class HttpUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present? && valid_url?(value)
      record.errors.add(attribute, "is not a valid HTTP URL")
    end
  end

  def valid_url?(value)
    uri = URI.parse(value)
    (uri.is_a?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && !uri.host.nil? && uri.host =~ %r{\.[a-zA-Z]{1,3}}
  rescue URI::InvalidURIError
    false
  end
end
