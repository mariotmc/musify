class SongSearchesController < ApplicationController
  def index
    @player_id = params[:player_id]
    @round_id = params[:round_id]

    if params[:query].present?
      @songs = RSpotify::Track.search(params[:query], limit: 6)
                              .select{|song| song.preview_url}
                              .map{|song| {id: song.id, title: song.name, artist: song.artists.first.name, image: song.album.images.second["url"], preview_url: song.preview_url}}
    else
      @songs = []
    end
  end

  def create
    @round = Round.find(params[:round_id])
    @player = Player.find(params[:player_id])
    @song = RSpotify::Track.find(params[:spotify_id])

    ActiveRecord::Base.transaction do
      song = Song.create!(round_id: params[:round_id], player_id: params[:player_id], spotify_id: @song.id, title: @song.name, artist: @song.artists.first.name, image: @song.album.images.second["url"], preview_url: @song.preview_url)
      song.round.start
    end
  end
end
