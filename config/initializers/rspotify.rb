if Rails.env.production?
  begin
    Rails.application.config.after_initialize do
      if Rails.application.credentials.spotify_client_id.present? &&
         Rails.application.credentials.spotify_client_secret.present?
        RSpotify.authenticate(
          Rails.application.credentials.spotify_client_id,
          Rails.application.credentials.spotify_client_secret
        )
      end
    end
  rescue StandardError => e
    Rails.logger.error "Failed to initialize RSpotify: #{e.message}"
  end
end
