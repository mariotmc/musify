class Player < ApplicationRecord
  AVATARS = %w[elephant fox giraffe koala monkey panda penguin polar_bear rabbit raccoon sloth tiger]
  AVATAR_BACKGROUND_COLORS = %w[#ff8387 #cef0a6 #9ae3f4 #b1eeff #c3b9fe #ffafbe #91ecef #91e0fe #93e0fe #d5a1f6 #a1e696 #c394e0]
  COLORS = %w[red orange amber yellow lime green emerald teal sky blue indigo violet purple fuchsia pink rose]

  belongs_to :lobby
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy

  validates :lobby_id, presence: true
  validates :name, presence: true, length: { maximum: 10 }
  validates :avatar, :color, presence: { message: "must be selected" }
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  after_create_commit :broadcast_player_created
  after_create_commit :broadcast_lobby_created, if: :first_player?
  after_destroy_commit :broadcast_player_removed
  after_destroy_commit :broadcast_lobby_removed, if: :last_player?

  def broadcast_player_created
    lobby.players.each do |player|
      broadcast_append_to("player_#{player.id}", target: "players", partial: "players/player", locals: { player: self })
      broadcast_replace_to("player_#{player.id}", target: "ready_players", partial: "ready/players", locals: { players: lobby.players })
    end
  end

  def broadcast_player_removed
    lobby.players.each do |player|
      broadcast_remove_to("player_#{player.id}", target: "lobby_#{lobby.id}_player_#{id}")
      broadcast_remove_to("player_#{player.id}", target: "player_#{id}_ready")
    end
  end

  def broadcast_lobby_created
    broadcast_prepend_to("lobbies", target: "lobbies", partial: "lobbies/lobby", locals: { lobby: lobby })
  end

  def broadcast_lobby_removed
    broadcast_remove_to("lobbies", target: "lobby_#{lobby.id}")
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

  def avatar_bg_color
    index = AVATARS.find_index(avatar)
    AVATAR_BACKGROUND_COLORS[index]
  end

  def ordinal_number_placement(number)
    return if number <= 3

    if (11..13).include?(number % 100)
      "th"
    else
      case number % 10
      when 1 then "st"
      when 2 then "nd"
      when 3 then "rd"
      else "th"
      end
    end
  end

  private
    def first_player?
      lobby.players.size == 1
    end

    def last_player?
      lobby.players.size == 0
    end
end
