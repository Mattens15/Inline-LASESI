# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_21_135820) do

  create_table "has_powers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prenotaziones", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "time_from"
    t.datetime "time_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "notes"
    t.integer "max_partecipans"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.integer "created_by"
    t.datetime "time_from"
    t.datetime "time_to"
    t.string "avatar_file"
    t.float "avatar_size"
    t.string "avatar_updated_at"
    t.string "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.boolean "admin"
    t.json "room_host"
    t.json "facebook"
    t.json "google"
    t.json "ratings"
    t.json "invitations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
