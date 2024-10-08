class SongSearchesController < ApplicationController
  def index
    @player_id = params[:player_id]
    @round_id = params[:round_id]
    @query = params[:query]

    if @query.present?
      @songs = RSpotify::Track.search(@query, limit: 6)
                              .select{|song| song.preview_url}
                              .map{|song| {id: song.id, title: song.name, artist: song.artists.first.name, image: song.album.images.second["url"], preview_url: song.preview_url}}
    else
      @songs = []
    end
  end

  def create
    redirect_to song_searches_path(query: params[:query]) and return if params[:spotify_id].blank?

    @round = Round.find(params[:round_id])
    @player = Player.find(params[:player_id])
    @song = RSpotify::Track.find(params[:spotify_id])

    ActiveRecord::Base.transaction do
      song = Song.create!(round_id: params[:round_id], player_id: params[:player_id], spotify_id: @song.id, title: @song.name, artist: @song.artists.first.name, image: @song.album.images.second["url"], preview_url: @song.preview_url)
      song.round.start
    end
  end
end
