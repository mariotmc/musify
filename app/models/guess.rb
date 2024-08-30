class Guess < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :song

  validates :player_id, :round_id, :song_id, presence: true
  validates :content, presence: true, length: { maximum: 100 }

  after_create :check_guess
  after_create_commit :broadcast_guess

  def broadcast_guess
    round.players.each do |player|
      broadcast_append_to("player_#{player.id}", target: "guesses", partial: "guesses/guess", locals: { guess: self })
    end
  end

  def mark_correct!
    player.add_points!(started: round.current_song.started_at, ended: Time.current)
    update!(correct: true)
    if round.all_players_guessed_correctly?
      round.current_song.player.add_points_for_song_owner!(correct_guesses: round.guesses.where(song: round.current_song, correct: true).size)
      round.finish_current_song!
    end
  end

  def check_guess
    if correct_guess?
      mark_correct!
    elsif close_guess?
      update!(close: true)
    end
  end

  def correct_guess?
    normalized_guess == normalized_answer ||
    normalized_guess == normalized_answer_without_apostrophes
  end

  def close_guess?
    return false if correct_guess?
    return false if normalized_guess.length < normalized_answer.length * 0.5

    word_by_word_close? || overall_close?
  end

  def normalized_guess
    normalize_string(content)
  end

  def normalized_answer
    normalize_string(round.current_song.display_name)
  end

  def normalized_answer_without_apostrophes
    normalize_string(round.current_song.display_name, remove_apostrophes: true)
  end

  private
    def normalize_string(str, remove_apostrophes: false)
      result = str.strip.downcase
      result = result.gsub(/[[:punct:]]/, '') if remove_apostrophes
      result = result.gsub(/[[:punct:]&&[^']]/, '') unless remove_apostrophes
      result.gsub(/\s+/, ' ')  # Replace multiple spaces with a single space
    end

    def word_by_word_close?
      guess_words = normalized_guess.split
      answer_words = normalized_answer.split

      return false if guess_words.length != answer_words.length

      guess_words.zip(answer_words).all? do |guess_word, answer_word|
        calculate_similarity(guess_word, answer_word) >= 0.75
      end
    end

    def overall_close?
      calculate_similarity(normalized_guess, normalized_answer) >= 0.8 ||
      calculate_similarity(normalized_guess, normalized_answer_without_apostrophes) >= 0.8
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
