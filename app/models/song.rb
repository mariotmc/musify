class Song < ApplicationRecord
  belongs_to :round
  belongs_to :player

  def display_name
    name.gsub(/\[.*?\]/, '').gsub(/\s*\(?\s*feat\.?.*$/i, '').gsub(/[[:punct:]]/, '').strip.downcase
  end
end
