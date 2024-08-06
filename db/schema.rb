# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_04_151938) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "lobby_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lobby_id"], name: "index_games_on_lobby_id"
  end

  create_table "guesses", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "round_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_guesses_on_player_id"
    t.index ["round_id"], name: "index_guesses_on_round_id"
  end

  create_table "lobbies", force: :cascade do |t|
    t.string "code"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.bigint "lobby_id", null: false
    t.string "name"
    t.boolean "host", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lobby_id"], name: "index_players_on_lobby_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "songs", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "player_id", null: false
    t.string "spotify_id"
    t.string "title"
    t.string "artist"
    t.string "image"
    t.string "preview_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_songs_on_player_id"
    t.index ["round_id"], name: "index_songs_on_round_id"
  end

  add_foreign_key "games", "lobbies"
  add_foreign_key "guesses", "players"
  add_foreign_key "guesses", "rounds"
  add_foreign_key "players", "lobbies"
  add_foreign_key "rounds", "games"
  add_foreign_key "songs", "players"
  add_foreign_key "songs", "rounds"
end
