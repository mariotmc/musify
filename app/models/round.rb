class Round < ApplicationRecord
  belongs_to :game
  has_many :songs, dependent: :destroy
end
