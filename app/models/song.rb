class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player

  after_create_commit -> { confirm_song }

  def confirm_song
    round.check_songs
  end
end
