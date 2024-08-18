class RoundsController < ApplicationController
  before_action :set_round

  def show
    @current_song = @round.current_song
  end

  def update
    @round.next_song!
  end

  private
    def set_round
      @round = Round.find(params[:id])
    end
end
