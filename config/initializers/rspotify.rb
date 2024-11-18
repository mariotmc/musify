unless Rails.env.test? || ENV["SECRET_KEY_BASE_DUMMY"]
  Rails.application.config.after_initialize do
    RSpotify.authenticate(Rails.application.credentials.spotify_client_id, Rails.application.credentials.spotify_client_secret)
  end
end
