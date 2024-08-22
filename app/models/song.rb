class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player
  has_many :guesses, dependent: :destroy

  def display_name
    title.gsub(/\[.*?\]/, '').gsub(/\s*\(?\s*feat\.?.*$/i, '').gsub(/[[:punct:]]/, '').strip
  end

  def record_start_time!
    update!(started_at: Time.current)
  end
end
