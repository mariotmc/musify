class SongsController < ApplicationController
  def new
    @song = Song.new
  end

  def create
    @song = Song.create!(song_params)

    if @song.save
      @song.confirm_song
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def song_params
      params.require(:song).permit(:round_id, :title, :artist, :spotify_id, :player_id)
    end
end
