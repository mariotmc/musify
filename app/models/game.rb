class Game < ApplicationRecord
  belongs_to :lobby
  has_many :players, through: :lobby
  has_many :rounds, dependent: :destroy
  has_many :songs, through: :rounds

  enum status: { waiting: 0, in_game: 1, finished: 2 }

  broadcasts_to ->(game) { "game_#{game.id}" }

  def start
    update(status: "started")
    broadcast_replace_to "game_#{id}", partial: "games/game", locals: { game: self }
    start_next_round
  end

  def start_next_round
    new_round = rounds.create
    broadcast_append_to "game_#{id}", partial: "rounds/round", locals: { round: new_round }
    RoundStartJob.perform_later(new_round)
  end
end
