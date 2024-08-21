class TimerJob < ApplicationJob
  def perform(round:, player:)
    round = Round.find(round.id)
    player = Player.find(player.id)

    return if round.status == "scoreboard"

    Current.player = player
    round.finish_current_song!
  end
end
