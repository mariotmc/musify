class Lobby < ApplicationRecord
  has_many :players, dependent: :destroy
  has_one :game, dependent: :destroy

  enum status: { waiting: 0, in_game: 1, finished: 2 }

  validates :code, presence: true, uniqueness: true, length: { is: 6 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  before_validation :generate_code
  after_create_commit -> { Game.create!(lobby: self) }

  private
    def generate_code
      self.code = SecureRandom.send(:choose, [*"a".."z"], 6)
    end
end
