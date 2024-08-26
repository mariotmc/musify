https://claude.ai/chat/993faa19-4b90-44a2-951c-67d06af17fed
https://developer.spotify.com/dashboard/8c6ed9e346ee4138b41deaa656898eaf/settings
https://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Player
https://excalidraw.com/

client_id = 8c6ed9e346ee4138b41deaa656898eaf
client_secret = 1066e11a240943c8af2ef7e0a31bb455

RSpotify.authenticate("8c6ed9e346ee4138b41deaa656898eaf", "1066e11a240943c8af2ef7e0a31bb455")
RSpotify::Track.search("do i wanna know?").first.id
RSpotify::Track.search("do i wanna know?").first.name
RSpotify::Track.search("do i wanna know?").first.artists
RSpotify::Track.search("do i wanna know?").first.preview_url
RSpotify::Track.search("do i wanna know?").first.album.images.second["url"]

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

- with > 1 player it appends all guesses to the chat but doesn't evaluate and plays always plays the first song (songs def saved correctly)
  - guess evaluation works when first song played for the second time (maybe something off with inital rounds/started render (Current.player changes related?))
- start new round after all songs played (create new round when all players ready)
  - rounds/ended needs to show scoreboard + new round ready button
  - maybe ended needs to emulate rounds/waiting and when all players ready we broadcast rounds/started?
  - def need new round broadcasts (broadcast_new_round_waiting, broadcast_new_round_started)
  - needs to set previous round current to false and new round as current
- if player guessed correctly disable their input (idk if overkill for mvp)
- remove redundant turbo_stream_from calls and reduce turbo_frame_tag names since it's user scoped
- model validations
- necessary edge cases (scoop up from AI chats)
- player display_name_color, avatar (take from songl.io)
- design + animations (animate.css, turbo 8 view transitions?, https://v0.dev/chat/v7u4XVdbDLi)
