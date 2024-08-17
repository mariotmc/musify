https://claude.ai/chat/993faa19-4b90-44a2-951c-67d06af17fed
https://developer.spotify.com/dashboard/8c6ed9e346ee4138b41deaa656898eaf/settings
https://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Player
https://excalidraw.com/

client_id = 8c6ed9e346ee4138b41deaa656898eaf
client_secret = 1066e11a240943c8af2ef7e0a31bb455
access_token = BQCvUZM8RQ2XbPwBv4rgvUSHEoxIrXE36kYplrEzE6VAz3DibqIQwrJ67bIVy0WUqLa_vopeU66q6HcL1j8fFD4qxDS_k6SCRUao2aI4BXW5NVpvBVBqm3r5Gii162Jke2cyyF2PVXvd3UnFovFJNuoUXts-HyqtE4j4iqdZQa8SaBXujZQEPahP-Q98J7uThfBmnnp0EWmgYORRUNbH9NWryDcQ5Q
refresh_token = AQBHZ6mFXrdtuv0bR-joBcOEK7ljn4NOsTt1RMOUOjEKEfhDgse1zQx5ZE3jZ8LGigL-7CMRdafqR7VNCBYwF4GbQluN9xN3pXE-jFCIpFAB7odfEDN71xD23kwgosxf4Xc

RSpotify.authenticate("8c6ed9e346ee4138b41deaa656898eaf", "1066e11a240943c8af2ef7e0a31bb455")
RSpotify::Track.search("do i wanna know?").first.id
RSpotify::Track.search("do i wanna know?").first.name
RSpotify::Track.search("do i wanna know?").first.artists
RSpotify::Track.search("do i wanna know?").first.preview_url
RSpotify::Track.search("do i wanna know?").first.album.images.second["url"]

PROPER AUTH (old one might still work)
`npm start` auth_code node app
http://localhost:8888/

GET TRACK INFO
curl --request GET 'https://api.spotify.com/v1/tracks/6epn3r7S14KUqlReYr77hA' --header "Authorization: Bearer BQCvUZM8RQ2XbPwBv4rgvUSHEoxIrXE36kYplrEzE6VAz3DibqIQwrJ67bIVy0WUqLa_vopeU66q6HcL1j8fFD4qxDS_k6SCRUao2aI4BXW5NVpvBVBqm3r5Gii162Jke2cyyF2PVXvd3UnFovFJNuoUXts-HyqtE4j4iqdZQa8SaBXujZQEPahP-Q98J7uThfBmnnp0EWmgYORRUNbH9NWryDcQ5Q"

TODO

- make Node auth fetching app work in this app (refactor it to rails)
  - refactor fetching songs (with new auth and possibly using HTTParty)
- flesh out steps for playing a round (guesses, timer, chat, hints etc.)
  - the chat box is a round.guesses form in disguise
