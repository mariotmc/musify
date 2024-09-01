class PlayersController < ApplicationController
  def new
    @lobby = Lobby.find_by(code: params[:code])
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      delete_player_from_existing_lobbies(Current.player) if Current.player
      session[:player_id] = @player.id
      Current.player = Player.find(session[:player_id])
      redirect_to lobby_path(@player.lobby.code)
    else
      @lobby = Lobby.find(params[:player][:lobby_id])
      render :new, status: :unprocessable_entity
    end
  end

  def update
    player = Player.find(session[:player_id])
    player.update!(player_params)
    head :ok
  end

  def destroy
    player = Player.find(session[:player_id])
    lobby = player.lobby
    player.destroy
    lobby.destroy if lobby.players.size == 0
    session[:player_id] = nil
    Current.player = nil
    redirect_to root_path
  end

  private
    def player_params
      params.require(:player).permit(:name, :lobby_id, :avatar, :color)
    end

    def delete_player_from_existing_lobbies(player)
      Player.where(id: player.id).destroy_all
    end
end
