begin
  RSpotify.authenticate(
    Rails.application.credentials.spotify_client_id,
    Rails.application.credentials.spotify_client_secret
  )
rescue StandardError => e
  Rails.logger.error "Failed to initialize RSpotify: #{e.message}"
end
