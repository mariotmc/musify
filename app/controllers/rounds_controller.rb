class RoundsController < ApplicationController
  before_action :set_round

  def show
  end

  def update
    @round.update!(round_params)
    head :no_content
  end

  private
    def set_round
      @round = Round.find(params[:id])
    end

    def round_params
      params.require(:round).permit(:status)
    end
end
