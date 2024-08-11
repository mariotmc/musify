class Lobby < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :game, dependent: :destroy

  enum status: { waiting: 0, in_game: 1, finished: 2 }

  before_create -> { self.code = SecureRandom.alphanumeric(6).downcase }
  after_create_commit -> { Game.create!(lobby: self) }
end
