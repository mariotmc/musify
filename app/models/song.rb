class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player
  has_many :guesses, dependent: :destroy

  def record_start_time!
    update!(started_at: Time.current)
  end

  def display_name
    title.gsub(/\[.*?\]/, '').gsub(/\s*\(?\s*feat\.?.*$/i, '').gsub(/[[:punct:]]/, '').strip.upcase
  end

  def visual_clue(reveal_type: :none)
    display_name.split.map do |word|
      case reveal_type
      when :first_letter
        word[0] + '_' * (word.length - 1)
      when :both_letters
        if word.length > 1
          word[0] + '_' * (word.length - 2) + word[-1]
        else
          word
        end
      else
        '_' * word.length
      end
    end.join(' ')
  end

  def initial_visual_clue
    visual_clue
  end

  def visual_clue_with_first_letters
    visual_clue(:first_letter)
  end

  def visual_clue_with_both_letters
    visual_clue(:both_letters)
  end
end
