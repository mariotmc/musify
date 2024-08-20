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

- flesh out steps for playing a round (guesses, timer, chat, hints etc.)
  - should play music when guessing
  - should go to scoreboard after each song
  - host button to get to the next song in standings partial
  - points based on how much time left (10 points per second left, e.g. 5 seconds left i.e. 25 seconds needed to guess correctly == 50 points (300 - 250))
  - visual timer
  - hints
  - if player's guess is close to being correct, the message should be (xyz was close!)
  - image less blurred the more time passes (decrease in 5-10s intervals?)
  - if player guessed correctly disable their input (idk if overkill for mvp)
- player display_name_color, avatar (take from songl.io)
- model validations
- necessary edge cases (scoop up from AI chats)
- design
