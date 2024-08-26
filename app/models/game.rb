class Game < ApplicationRecord
  belongs_to :lobby
  has_many :players, through: :lobby
  has_many :songs, through: :rounds
  has_many :rounds, dependent: :destroy
  has_one :current_round, -> { where(current: true) }, class_name: "Round"

  enum status: { waiting: 0, started: 1, ended: 2 }

  after_create_commit -> { rounds.create!(current: true) }
  after_update_commit -> { broadcast_game_started if saved_change_to_status? && started? }

  def broadcast_game_started
    broadcast_replace_to("game_#{id}", partial: "games/game", locals: { game: self }, target: "game_#{id}")
  end

  def broadcast_player_ready(player)
    broadcast_replace_to("lobby_#{player.lobby.id}_players", partial: "players/player", locals: { player: player }, target: "player_#{player.id}")
  end

  def all_players_ready?
    players.all?(&:ready?)
  end

  def start_if_all_ready
    return unless all_players_ready?
    players.each { |player| player.update!(ready: false) }
    update!(status: "started")
  end
end
