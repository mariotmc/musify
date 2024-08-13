class Round < ApplicationRecord
  belongs_to :game
  has_many :songs, dependent: :destroy

  scope :current, -> { where(current: true) }

  def check_songs
    all_songs_received? ? broadcast_start_round : broadcast_waiting_for_players
  end

  def all_songs_received?
    songs.size == game.lobby.players.size
  end

  def broadcast_start_round
    # broadcast_update_to("round_#{id}", partial: "rounds/round", locals: { round: self }, target: "round_#{id}")
    p "-----------------"
    pp "STARTING ROUND"
    p "-----------------"
  end

  def broadcast_waiting_for_players
    # broadcast_update_to("round_#{id}", partial: "rounds/round", locals: { round: self }, target: "round_#{id}")
    # THIS SHOULD ONLY BE FOR CURRENT USER (turbo stream instead?)
    p "-----------------"
    pp "WAITING FOR OTHER PLAYERS"
    p "-----------------"
  end
end
