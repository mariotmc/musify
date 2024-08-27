class Player < ApplicationRecord
  belongs_to :lobby
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  after_create_commit -> { broadcast_player_created }
  after_destroy_commit -> { broadcast_player_removed }

  def broadcast_player_created
    broadcast_append_to("lobby_#{lobby.id}_players", partial: "players/player", locals: { player: self }, target: "lobby_#{lobby.id}_players")
  end

  def broadcast_player_removed
    broadcast_remove_to("lobby_#{lobby.id}_players", target: "player_#{self.id}")
  end

  def ready!
    update!(ready: true)
  end

  def unready!
    update!(ready: false)
  end

  def created_song_for_current_round?
    songs.exists?(round: lobby.game.current_round)
  end

  def guessed_song_correctly?(song:)
    guesses.exists?(song: song, correct: true)
  end

  def add_points!(started:, ended:)
    points_per_second = 10
    max_time = 30
    time_left = ended.to_i - started.to_i
    points = (max_time - time_left) * points_per_second
    update!(score: self.score + points)
  end

  def add_points_for_song_owner!(correct_guesses:)
    points_per_correct_guess = 50
    update!(score: self.score + (correct_guesses * points_per_correct_guess))
  end
end
