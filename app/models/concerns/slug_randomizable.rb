require 'securerandom'

module SlugRandomizable
  extend ActiveSupport::Concern

  DEFAULT_SLUG_SIZE = 15

  def randomize_slug
    SecureRandom.alphanumeric(DEFAULT_SLUG_SIZE)
  end
end