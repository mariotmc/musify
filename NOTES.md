https://claude.ai/chat/993faa19-4b90-44a2-951c-67d06af17fed
https://developer.spotify.com/dashboard/8c6ed9e346ee4138b41deaa656898eaf/settings
https://www.rubydoc.info/github/guilhermesad/rspotify/master/RSpotify/Player
https://excalidraw.com/
RSpotify.authenticate("8c6ed9e346ee4138b41deaa656898eaf", "1066e11a240943c8af2ef7e0a31bb455")
RSpotify::Track.search("do i wanna know?").first.id
RSpotify::Track.search("do i wanna know?").first.name
RSpotify::Track.search("do i wanna know?").first.artists
RSpotify::Track.search("do i wanna know?").first.preview_url
RSpotify::Track.search("do i wanna know?").first.album.images.second["url"]

TODO

- implement song form properly (spotify song search, display results (incl preview), submit proper song attributes)
- flesh out steps for playing a round (guesses, timer, chat, hints etc.)
  - the chat box is a round.guesses form in disguise
