class Player < ApplicationRecord
  belongs_to :lobby
  has_many :songs, dependent: :destroy

  after_create_commit -> { broadcast_player_created }
  after_destroy_commit -> { broadcast_player_removed }

  def broadcast_player_created
    broadcast_append_to("lobby_#{lobby.id}_players", partial: "players/player", locals: { player: self }, target: "lobby_#{lobby.id}_players")
  end

  def broadcast_player_removed
    broadcast_remove_to("lobby_#{lobby.id}_players", target: "player_#{self.id}")
  end

  def created_song_for_current_round?
    songs.exists?(round: lobby.game.current_round)
  end
end
