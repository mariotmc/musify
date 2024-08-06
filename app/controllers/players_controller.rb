class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @player = Player.create!(player_params)
  end

  private
    def player_params
      params.require(:player).permit(:lobby_id, :name)
    end

    def lobby
      @lobby ||= Lobby.find(params[:lobby])
    end
end
