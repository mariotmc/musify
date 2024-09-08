https://developer.spotify.com/dashboard/8c6ed9e346ee4138b41deaa656898eaf/settings

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

- edge cases
  - player joining mid game (works, but will mess up places where we depend on)
  - player leaving mid game (https://claude.ai/chat/c219349e-104d-4ae7-97ed-f085c2f3daf1)
    - if player leaves on scoreboard screen it will try to play next song (but song deleted bc player left)
  - disconnections and reconnections (too much, just leave it?)
  - refreshing will start visual timer over (backend still works as intended)
- design
  - next song/new round layout should be player size depended (grid if more than 4)
  - create a volume slider that shows top left of main view
    - players can at any time adjust the volume which will set a value in local storage
    - the value in local storage will be used to apply to the volume of each playback (while picking song and during the round)
  - logo in lobbies view
    - remove delete lobbies button
    - when creating new lobby it should redirect you to that lobby
- do test run with group (just a few rounds) and if current spotify api is too limited rewrite song fetching
