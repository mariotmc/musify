class LobbiesController < ApplicationController
  before_action :authenticate_player!, only: [:show]

  def index
    @lobbies = Lobby.all
  end

  def show
    @lobby = Lobby.find_by(code: params[:code])
  end

  private
    def authenticate_player!
      redirect_to new_player_path(lobby: @lobby) unless Current.player.present?
    end
end
