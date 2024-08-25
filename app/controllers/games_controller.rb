class GamesController < ApplicationController
  before_action :set_game, only: [:update, :ready, :unready]
  before_action :set_player, only: [:ready, :unready]

  def update
    @game.update!(game_params)
    head :no_content
  end

  def ready
    @player.ready!
    @game.broadcast_player_ready(@player)
    @game.start_if_all_ready
  end

  def unready
    @player.unready!
    @game.broadcast_player_ready(@player)
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def set_player
      @player = Player.find(params[:player_id])
    end

    def game_params
      params.require(:game).permit(:status)
    end
end
