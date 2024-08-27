class TimerJob < ApplicationJob
  def perform(round:)
    round = Round.find(round.id)

    return if round.status == "scoreboard" || round.status == "ended"

    round.finish_current_song!
  end
end
