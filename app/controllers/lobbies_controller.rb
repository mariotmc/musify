class LobbiesController < ApplicationController
  before_action :set_lobby, :authenticate_player!, only: [:show]

  def index
    @lobbies = Lobby.all
  end

  def create
    @lobby = Lobby.create!
  end

  def show
  end

  def destroy
    Lobby.destroy_all
    render turbo_stream: turbo_stream.update("lobbies")
  end

  private
    def set_lobby
      @lobby = Lobby.find_by(code: params[:code])
    end

    def authenticate_player!
      redirect_to new_player_path(code: @lobby.code) if Current.player.nil? || Current.player.lobby != @lobby
    end
end
