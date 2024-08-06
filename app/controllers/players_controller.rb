class PlayersController < ApplicationController
  def new
    @lobby = Lobby.find_by(code: params[:code])
    @player = Player.new
  end

  def create
    @player = Player.create!(player_params)

    if @player.save
      session[:player_id] = @player.id
      Current.player = Player.find(session[:player_id])
      @player.update!(host: true) if @player.lobby.players.size == 1
      redirect_to lobby_path(@player.lobby.code)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    player = Player.find(session[:player_id])
    player.destroy
    session[:player_id] = nil
    Current.player = nil
    redirect_to root_path
  end

  private
    def player_params
      params.require(:player).permit(:lobby_id, :name)
    end
end
