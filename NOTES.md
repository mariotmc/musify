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

- if player guessed correctly disable their input (TEST THIS -> need 3 players)
- check song that have words like "you're" and see how it's displayed and either change how it works or create disclaimer
- remove redundant turbo_stream_from calls and reduce turbo_frame_tag names since it's user scoped
- model validations
- necessary edge cases (scoop up from AI chats)
- player display_name_color, avatars
- favicon
- design (scoring system explanation in pre round lobby, disclaimer that Spotify API might not have every song in song searches form view) + animations (animate.css, turbo 8 view transitions?, https://v0.dev/chat/v7u4XVdbDLi, https://v0.dev/chat/l2KRrtd1zvk)
