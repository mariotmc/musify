class Round < ApplicationRecord
  belongs_to :game
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  after_update_commit -> { broadcast_round }, if: -> { saved_change_to_status? }

  enum status: { waiting: 0, started: 1, scoreboard: 2, ended: 3 }

  scope :current, -> { where(current: true) }

  def broadcast_round
    broadcast_replace_to("round_#{id}", target: "round_#{id}", partial: "rounds/round", locals: { round: self })
  end

  def start
    start_round if all_songs_received?
  end

  def current_song
    songs[current_song_index]
  end

  def finish_current_song!
    if next_song?
      update!(current_song_index: current_song_index + 1)
    end

    update!(status: "scoreboard")
  end

  def next_song!
    update!(status: "started")
  end

  def start_next_song
    broadcast_round
    start_timer
  end

  def all_players_guessed_correctly?
    correct_guesses_for_current_song = guesses.where(song: current_song, correct: true).size
    correct_guesses_for_current_song == game.players.size
  end

  def next_song?
    current_song_index <= songs.size - 1
  end

  private
    def start_round
      shuffle_songs
      next_song!
      start_timer
    end

    def all_songs_received?
      songs.size >= game.lobby.players.size
    end

    def start_timer
      # TimerJob.set(wait: 30.seconds).perform_later(round: self, player: Current.player)
    end

    def shuffle_songs
      self.songs = self.songs.shuffle
    end
end
