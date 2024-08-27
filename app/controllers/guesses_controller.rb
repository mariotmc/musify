class GuessesController < ApplicationController
  def create
    @round = Round.find(params[:round_id])
    @player = Player.find(params[:player_id])
    @guess = @round.guesses.build(guess_params)
    @guess.save!
    head :ok
  end

  private
    def guess_params
      params.require(:guess).permit(:song_id, :player_id, :content)
    end
end
