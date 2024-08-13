class Round < ApplicationRecord
  belongs_to :game
  has_many :songs, dependent: :destroy

  after_update_commit -> { broadcast_round }

  enum status: { waiting: 0, started: 1, ended: 2 }

  scope :current, -> { where(current: true) }

  def start
    update!(status: "started") if all_songs_received?
  end

  def all_songs_received?
    songs.size >= game.lobby.players.size
  end

  def broadcast_round
    broadcast_update_to("round_#{id}", target: "round_#{id}", partial: "rounds/round", locals: { round: self })
  end
end
