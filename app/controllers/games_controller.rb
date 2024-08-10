class GamesController < ApplicationController
  def update
    @game = Game.find(params[:id])
    @game.update!(game_params)
    head :no_content
  end

  private
    def game_params
      params.require(:game).permit(:status)
    end
end
