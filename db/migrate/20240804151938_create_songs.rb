class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.references :round, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :spotify_id
      t.string :title
      t.string :artist
      t.string :image
      t.string :preview_url
      t.datetime :started_at

      t.timestamps
    end
  end
end
