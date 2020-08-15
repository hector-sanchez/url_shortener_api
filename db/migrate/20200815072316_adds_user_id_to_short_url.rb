class AddsUserIdToShortUrl < ActiveRecord::Migration[6.0]
  def change
    add_reference :short_urls, :user, foreign_key: true
  end
end
