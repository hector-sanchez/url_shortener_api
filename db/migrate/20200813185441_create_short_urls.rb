class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
      t.string :slug, null: false
      t.datetime :expire_at
      t.string :original_url, null: false
      
      t.index :slug, unique: true

      t.timestamps
    end
  end
end
