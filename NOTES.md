PROPER AUTH
`npm start` auth_code node app
http://localhost:8888/

SEARCH SPECIFIC TRACK
curl --request GET 'https://api.spotify.com/v1/tracks/<track_id>' --header "Authorization: Bearer <access_token>"
response = RestClient.get('https://api.spotify.com/v1/tracks/6epn3r7S14KUqlReYr77hA', { Authorization: "Bearer #{request.env["omniauth.auth"]["credentials"]["token"]}"})

SEARCH TRACKS
response = RestClient.get('https://api.spotify.com/v1/search', { params: { q: <query>, type: 'track' },
Authorization: "Bearer #{request.env["omniauth.auth"]["credentials"]["token"]}"})
tracks = JSON.parse(response.body)['tracks']['items']

TODO

- timer has delay, because UI is handled client side with stimulus while execution logic is handled with background job and they're not in sync (stimulus does time update, image unblur, smooth countdown with changing colours)
  - handle everything server side
- edge cases
  - player joining mid game (works, but will mess up places where we depend on)
  - player leaving mid game (https://claude.ai/chat/c219349e-104d-4ae7-97ed-f085c2f3daf1)
    - if player leaves on scoreboard screen it will try to play next song (but song deleted bc player left)
  - disconnections and reconnections (too much, just leave it?)
  - refreshing will start visual timer over (backend still works as intended)
