class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :status, default: 0
      t.boolean :current, default: false
      t.integer :current_song_index, default: 0

      t.timestamps
    end
  end
end
