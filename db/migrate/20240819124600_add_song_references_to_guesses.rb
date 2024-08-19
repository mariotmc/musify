class AddSongReferencesToGuesses < ActiveRecord::Migration[7.1]
  def change
    add_reference :guesses, :song, null: false, foreign_key: true
  end
end
