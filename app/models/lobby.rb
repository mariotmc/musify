class Lobby < ApplicationRecord
  has_many :players
  has_one :game

  enum status: { waiting: 0, in_game: 1, finished: 2 }

  before_create -> { self.code = SecureRandom.alphanumeric(6) }
end
