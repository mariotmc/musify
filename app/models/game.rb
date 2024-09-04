class Game < ApplicationRecord
  belongs_to :lobby
  has_many :players, through: :lobby
  has_many :songs, through: :rounds
  has_many :rounds, dependent: :destroy
  has_one :current_round, -> { where(current: true) }, class_name: "Round"

  enum status: { waiting: 0, started: 1, ended: 2 }

  validates :lobby_id, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  after_create_commit -> { rounds.create!(current: true) }
  after_update_commit :broadcast_game_started, if: -> { saved_change_to_status? && started? }

  def broadcast_game_started
    players.each do |player|
      broadcast_update_to("player_#{player.id}", target: "game", partial: "games/game", locals: { game: self, player: player })
    end
  end

  def broadcast_player_ready(player)
    players.each do |p|
      broadcast_update_to("player_#{p.id}", target: "player_#{player.id}_ready_status", partial: "ready/player_status", locals: { player: player })
    end
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
