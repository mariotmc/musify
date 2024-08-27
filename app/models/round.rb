class Round < ApplicationRecord
  belongs_to :game
  has_many :players, through: :game
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  after_update_commit -> { broadcast_round }, if: -> { saved_change_to_status? && !waiting? }

  enum status: { waiting: 0, started: 1, scoreboard: 2, ended: 3 }

  scope :current, -> { where(current: true) }

  def broadcast_round
    players.each do |player|
      broadcast_replace_to("lobby_#{game.lobby.id}_player_#{player.id}", target: "round_#{id}", partial: "rounds/round", locals: { round: self, player: player })
    end
  end

  def broadcast_player_ready(player)
    broadcast_replace_to("lobby_#{player.lobby.id}_players", partial: "players/player", locals: { player: player }, target: "player_#{player.id}")
  end

  def start
    next_song! if all_songs_received?
  end

  def current_song
    songs.order(:created_at)[current_song_index]
  end

  def finish_current_song!
    if more_songs?
      update!(current_song_index: current_song_index + 1)
      update!(status: "scoreboard")
    else
      update!(current_song_index: 0)
      update!(status: "ended")
    end
  end

  def next_song!
    update!(status: "started")
    current_song.record_start_time!
    start_timer
  end

  def more_songs?
    current_song_index < songs.size - 1
  end

  def all_players_guessed_correctly?
    correct_guesses_for_current_song = guesses.where(song: current_song, correct: true).size
    correct_guesses_for_current_song == game.players.size - 1
  end

  def start_if_all_ready
    return unless all_players_ready?
    players.each { |player| player.update!(ready: false) }
    next_song!
  end

  private
    def all_players_ready?
      players.all?(&:ready?)
    end

    def all_songs_received?
      songs.size >= game.lobby.players.size
    end

    def start_timer
      TimerJob.set(wait: 30.seconds).perform_later(round: self)
    end
end
