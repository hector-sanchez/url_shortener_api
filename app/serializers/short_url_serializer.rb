class ShortUrlSerializer
  include FastJsonapi::ObjectSerializer
  
  belongs_to :user

  attributes :slug, :original_url, :shortened_url, :expire_at, :user_id

  cache_options enabled: true, cache_length: 12.hours
end
