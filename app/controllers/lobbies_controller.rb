class LobbiesController < ApplicationController
  before_action :set_lobby, :authenticate_player!, only: [:show]

  def index
    @lobbies = Lobby.all
  end

  def show
  end

  private
    def set_lobby
      @lobby = Lobby.find_by(code: params[:code])
    end

    def authenticate_player!
      @current_player = Player.find_by(id: session[:player_id])
      redirect_to new_player_path(code: @lobby.code) if @current_player.nil?
    end
end
