class Player < ApplicationRecord
  AVATARS = %w[elephant fox giraffe koala monkey panda penguin polar_bear rabbit raccoon sloth tiger]
  AVATAR_BACKGROUND_COLORS = %w[#ff8387 #cef0a6 #9ae3f4 #b1eeff #c3b9fe #ffafbe #91ecef #91e0fe #93e0fe #d5a1f6 #a1e696 #c394e0]
  COLORS = %w[red orange amber yellow lime green emerald teal sky blue indigo violet purple fuchsia pink rose]

  belongs_to :lobby
  has_many :songs, dependent: :destroy
  has_many :guesses, dependent: :destroy
  has_one_attached :avatar

  validates :lobby_id, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :color, presence: true, inclusion: { in: COLORS }
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  after_create_commit :broadcast_player_created
  after_destroy_commit :broadcast_player_removed

  def broadcast_player_created
    lobby.players.each do |player|
      broadcast_append_to("player_#{player.id}", target: "players", partial: "players/player", locals: { player: self })
    end
  end

  def broadcast_player_removed
    lobby.players.each do |player|
      broadcast_remove_to("player_#{player.id}", target: "lobby_#{lobby.id}_player_#{id}")
    end
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
    avatar_name = avatar.attachment.blob[:filename].gsub(/\.png\z/, "")
    index = AVATARS.find_index(avatar_name)
    AVATAR_BACKGROUND_COLORS[index]
  end
end
