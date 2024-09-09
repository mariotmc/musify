class LobbiesController < ApplicationController
  before_action :set_lobby, :authenticate_player!, only: [:show]

  def index
    @lobbies = Lobby.joins(:players).group("lobbies.id").having("COUNT(players.id) > 0").order("created_at DESC")
  end

  def create
    @lobby = Lobby.create!
    redirect_to lobby_path(@lobby.code)
  end

  def show
  end

  private
    def set_lobby
      @lobby = Lobby.find_by(code: params[:code])
    end

    def authenticate_player!
      redirect_to new_player_path(code: @lobby.code) if Current.player.nil? || Current.player.lobby != @lobby
    end
end
