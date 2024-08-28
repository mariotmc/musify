class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player
  has_many :guesses, dependent: :destroy

  def record_start_time!
    update!(started_at: Time.current)
  end

  def display_name
    title
      .gsub(/\[.*?\]/, '') # Remove content in square brackets
      .gsub(/\s*\(?\s*feat\.?.*$/i, '') # Remove featuring artists
      .gsub(/[[:punct:]&&[^']]/, '') # Remove all punctuation except apostrophes
      .strip
      .upcase
  end

  def hint(reveal_type: :none)
    display_name.chars.chunk_while { |i, j| i != ' ' && j != ' ' }.map do |word|
      hint_for_word(word, reveal_type)
    end.join(' ')
  end

  def initial_hint
    hint
  end

  def hint_with_first_letters
    hint(reveal_type: :first_letter)
  end

  def hint_with_both_letters
    hint(reveal_type: :both_letters)
  end

  private
    def hint_for_word(word, reveal_type)
      word.map.with_index do |char, index|
        if char == "'"
          "'"
        elsif reveal_type == :none
          char == " " ? " " : "_ "
        elsif reveal_type == :first_letter
          if index == 0 && word.length > 1
            "#{char} "
          else
            char == " " ? " " : "_ "
          end
        elsif reveal_type == :both_letters
          if (index == 0 || index == word.length - 1) && word.length > 1
            "#{char} "
          else
            char == " " ? " " : "_ "
          end
        end
      end.join.strip
    end
end
