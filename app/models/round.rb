class Round < ApplicationRecord
  belongs_to :game
  has_many :players, through: :game
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  enum status: { waiting: 0, started: 1, scoreboard: 2, ended: 3 }

  validates :game_id, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :current_song_index, numericality: { greater_than_or_equal_to: 0 }

  after_update_commit :broadcast_round, if: -> { saved_change_to_status? && !waiting? }

  scope :current, -> { where(current: true) }

  def broadcast_round(round: self)
    players.each do |player|
      broadcast_replace_to("player_#{player.id}", target: "round_#{id}", partial: "rounds/round", locals: { round: round, player: player })
    end
  end

  def broadcast_player_ready(player)
    players.each do |p|
      broadcast_replace_to("player_#{p.id}", target: "player_#{player.id}_ready_button", partial: "ready/player_button", locals: { player: player })
    end
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
      update!(status: "ended")
    end
  end

  def next_song!
    if all_songs_played?
      update!(current: false)
      new_round = game.rounds.create!(current: true, status: "waiting")
      broadcast_round(round: new_round)
    else
      update!(status: "started")
      current_song.record_start_time!
      start_timer
    end
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

    def all_songs_played?
      ended?
    end

    def start_timer
      TimerJob.set(wait: 30.seconds).perform_later(round: self, song: self.current_song)
    end
end
