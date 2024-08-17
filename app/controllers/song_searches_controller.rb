class SongSearchesController < ApplicationController
  def index
    @player_id = params[:player_id]
    @round_id = params[:round_id]

    if params[:query].present?
      @all_songs = RSpotify::Track.search(params[:query], limit: 25)
      @songs = @all_songs.select { |song| song.preview_url.present? }.first(12)
    else
      @songs = []
    end
  end

  def create
    @round = Round.find(params[:round_id])
    @song = RSpotify::Track.find(params[:spotify_id])

    ActiveRecord::Base.transaction do
      song = Song.create!(round_id: params[:round_id], player_id: params[:player_id], spotify_id: @song.id, title: @song.name, artist: @song.artists.first.name, image: @song.album.images.second["url"], preview_url: @song.preview_url)
      song.round.start
    end
  end
end
