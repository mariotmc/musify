class GuessesController < ApplicationController
  def create
    @round = Round.find(params[:round_id])
    @guess = @round.guesses.build(guess_params)
    @guess.player = Current.player
    @guess.save!
    head :ok
  end

  private
    def guess_params
      params.require(:guess).permit(:song_id, :content)
    end
end
