class TimerJob < ApplicationJob
  def perform(round_id)
    Round.find(round_id).next_song!
  end
end
