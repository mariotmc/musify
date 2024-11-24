class TimerJob < ApplicationJob
  queue_as :default

  before_perform do
    ActiveStorage::Current.url_options = { host: "localhost", port: 3000 }
  end

  def perform(round:, song:)
    return unless round && song
    return if round.status == "scoreboard" || round.status == "ended"
    return if song != round.current_song

    round.finish_current_song!
  end
end
