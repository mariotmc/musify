class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player

  def display_name
    title.gsub(/\[.*?\]/, '').gsub(/\s*\(?\s*feat\.?.*$/i, '').gsub(/[[:punct:]]/, '').strip
  end
end
