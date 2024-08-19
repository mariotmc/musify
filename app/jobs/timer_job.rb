class TimerJob < ApplicationJob
  def perform(round:, player:)
    Current.player = Player.find(player.id)
    Round.find(round.id).next_song!
  end
end
