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
  - for each avatar the boundary offsets go down with block, right with inline-block
    - go step by step and make it work without avatar collision first
  - website name
  - logo might need text (https://app.recraft.ai/project/da8356de-04a0-4946-92cb-a2da49471da4)
  - scoring system explanation in pre round lobby
  - disclaimer that Spotify API might not have every song in song searches form view
  - animations (animate.css, turbo 8 view transitions, https://v0.dev/chat/v7u4XVdbDLi, https://v0.dev/chat/l2KRrtd1zvk)
