class ShortUrl < ApplicationRecord
  include SlugRandomizable

  after_initialize :generate_slug

  scope :active, ->() { where("expire_at > ?", DateTime.now) }

  validates :slug, uniqueness: true, presence: true
  validates :original_url, presence: true, http_url: true

  SHORTENED_URL_PREFIX = "http://www.goldbelly.com/".freeze

  def shortened_url
    SHORTENED_URL_PREFIX + slug
  end

  def expired?
    expire_at < DateTime.now
  end

  def expire!
    update(expire_at: 1.day.ago)
  end

  private

    def generate_slug
      return if persisted? || slug&.strip.present?

      self.slug = randomize_slug
    end
end
