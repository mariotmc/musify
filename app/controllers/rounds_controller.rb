class RoundsController < ApplicationController
  before_action :set_round
  before_action :set_player, only: [:ready, :unready]

  def update
    @round.update!(round_params)
    head :no_content
  end

  def ready
    @player.ready!
    @round.broadcast_player_ready(@player)
    @round.start_if_all_ready
  end

  def unready
    @player.unready!
    @round.broadcast_player_ready(@player)
  end

  private
    def set_round
      @round = Round.find(params[:id])
    end

    def set_player
      @player = Player.find(params[:player_id])
    end

    def round_params
      params.require(:round).permit(:status)
    end
end
