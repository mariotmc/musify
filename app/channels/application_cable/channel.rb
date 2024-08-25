module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      stream_from current_player
    end

    def unsubscribed
      current_player.unsubscribed
    end
  end
end
