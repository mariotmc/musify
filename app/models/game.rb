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
end
