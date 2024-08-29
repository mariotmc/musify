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
    display_name.split.map do |word|
      hint_for_word(word, reveal_type)
    end.join('  ')
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
      word.chars.map.with_index do |char, index|
        if char == "'"
          "'"
        elsif reveal_type == :none
          '_'
        else
          reveal_letter?(word, index, reveal_type) ? char : '_'
        end
      end.join
    end

    def reveal_letter?(word, index, reveal_type)
      case word.length
      when 1
        false
      when 2, 3
        index == 0 && reveal_type != :none
      else
        if reveal_type == :first_letter
          index == 0
        elsif reveal_type == :both_letters
          index == 0 || index == word.length - 1
        else
          false
        end
      end
    end
end
