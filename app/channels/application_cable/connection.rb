module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    protected
      def find_verified_player
        if Current.player.present?
          Current.player
        else
          reject_unauthorized_connection
        end
      end
  end
end
