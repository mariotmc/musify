class GuessesController < ApplicationController
  def create
    @round = Round.find(params[:round_id])
    @guess = @round.guesses.build(guess_params)
    @guess.player = current_player
    @guess.save
    @round.check_round_status
    head :ok
  end

  private
    def guess_params
      params.require(:guess).permit(:content)
    end
end
