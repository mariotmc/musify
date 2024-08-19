class Guess < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :song

  after_create :mark_correct!, if: :correct_guess?
  after_create_commit :broadcast_guess

  def broadcast_guess
    broadcast_append_to("round_#{round.id}_guesses", target: "round_#{round.id}_guesses", partial: "guesses/guess", locals: { guess: self })
  end

  def mark_correct!
    update!(correct: true)
    round.next_song! if round.all_players_guessed_correctly?
  end

  def correct_guess?
    content.strip.downcase == round.current_song.display_name.downcase
  end

  def correct?
    correct
  end
end
