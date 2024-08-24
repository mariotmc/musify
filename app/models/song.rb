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

  def hint(reveal_type: :none)
    display_name.split.map do |word|
      case reveal_type
      when :first_letter
        word.length == 1 ? '_' : word[0] + '_' * (word.length - 1)
      when :both_letters
        if word.length == 1
          '_'
        elsif word.length <= 3
          word[0] + '_' * (word.length - 1)
        else
          word[0] + '_' * (word.length - 2) + word[-1]
        end
      else
        '_' * word.length
      end
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
end
