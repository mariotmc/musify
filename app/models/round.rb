class Round < ApplicationRecord
  belongs_to :game
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  after_update_commit -> { broadcast_round }, if: -> { saved_change_to_status? }
  after_update_commit -> { start_next_round }, if: -> { saved_change_to_current_song_index? }

  enum status: { waiting: 0, started: 1, scoreboard: 2, ended: 3 }

  scope :current, -> { where(current: true) }

  def broadcast_round
    broadcast_update_to("round_#{id}", target: "round_#{id}", partial: "rounds/round", locals: { round: self })
  end

  def start
    start_round if all_songs_received?
  end

  def current_song
    songs[current_song_index]
  end

  def next_song!
    if current_song_index < songs.size - 1
      update!(current_song_index: current_song_index + 1)
    else
      update!(status: "scoreboard")
    end
    # this should be called when all players have guessed the song as well (would need a check to see if all players have guessed correctly which should probably happen on every correct guess)
  end

  def start_next_round
    broadcast_round
    start_timer
  end

  def all_players_guessed_correctly?
    (guesses.where(correct: true).size / (current_song_index + 1)) == (game.players.size * songs.size / (current_song_index + 1))
  end

  private
    def start_round
      shuffle_songs
      update!(status: "started")
      start_timer
    end

    def all_songs_received?
      songs.size >= game.lobby.players.size
    end

    def start_timer
      TimerJob.set(wait: 30.seconds).perform_later(id)
    end

    def shuffle_songs
      self.songs = self.songs.shuffle
    end
end
