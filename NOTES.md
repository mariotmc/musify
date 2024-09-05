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
  - round started view
  - show player ready status when waiting for other players to pick song instead of image
    - when a player submitted a song set status to ready and show statuses (reset when song starts playing)
  - icons for buttons (https://chatgpt.com/c/66d78660-7968-8008-bc51-e794e25ac76e)
  - website name
  - logo might need text (https://app.recraft.ai/project/da8356de-04a0-4946-92cb-a2da49471da4)
  - animations (animate.css, turbo 8 view transitions, https://v0.dev/chat/v7u4XVdbDLi, https://v0.dev/chat/l2KRrtd1zvk)
- do test run with group (just a few rounds) and if current spotify api is too limited rewrite song fetching
