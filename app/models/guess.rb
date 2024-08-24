class Guess < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :song

  after_create :check_guess
  after_create_commit :broadcast_guess

  def broadcast_guess
    broadcast_append_to("round_#{round.id}_guesses", target: "round_#{round.id}_guesses", partial: "guesses/guess", locals: { guess: self })
  end

  def mark_correct!
    player.add_points!(started: round.current_song.started_at, ended: Time.current)
    update!(correct: true)
    round.finish_current_song! if round.all_players_guessed_correctly?
  end

  def check_guess
    if correct_guess?
      mark_correct!
    elsif close_guess?
      update!(close: true)
    end
  end

  def correct_guess?
    normalized_guess == normalized_answer
  end

  def close_guess?
    return false if correct_guess?
    return false if normalized_guess.length < normalized_answer.length * 0.5

    word_by_word_close? || overall_close?
  end

  def normalized_guess
    content.strip.downcase.gsub(/[^\w\s]/, '')
  end

  def normalized_answer
    round.current_song.display_name.downcase.gsub(/[^\w\s]/, '')
  end

  private
    def word_by_word_close?
      guess_words = normalized_guess.split
      answer_words = normalized_answer.split

      return false if guess_words.length != answer_words.length

      guess_words.zip(answer_words).all? do |guess_word, answer_word|
        calculate_similarity(guess_word, answer_word) >= 0.75
      end
    end

    def overall_close?
      calculate_similarity(normalized_guess, normalized_answer) >= 0.8
    end

    def calculate_similarity(s1, s2)
      longer = [s1.length, s2.length].max
      (longer - calculate_levenshtein_distance(s1, s2)) / longer.to_f
    end

    def calculate_levenshtein_distance(s, t)
      m = s.length
      n = t.length
      return m if n == 0
      return n if m == 0

      d = Array.new(m+1) { Array.new(n+1) }

      (0..m).each { |i| d[i][0] = i }
      (0..n).each { |j| d[0][j] = j }

      (1..n).each do |j|
        (1..m).each do |i|
          d[i][j] = if s[i-1] == t[j-1]
                      d[i-1][j-1]
                    else
                      [d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+1].min
                    end
        end
      end

      d[m][n]
    end
end
