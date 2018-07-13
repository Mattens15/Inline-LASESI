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

ActiveRecord::Schema.define(version: 2018_07_02_234121) do

  create_table "messages", id: false, force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.integer "id"
    t.boolean "pinned", default: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "powers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_powers_on_room_id"
    t.index ["user_id", "room_id"], name: "index_powers_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_powers_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.boolean "reminder", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["user_id", "room_id"], name: "index_reservations_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "fifo"
    t.integer "max_participants"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.boolean "private", default: false
    t.datetime "max_unjoin_time"
    t.datetime "time_from"
    t.datetime "time_to"
    t.text "recurrence"
    t.string "event_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "hash_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "swap_reservations", force: :cascade do |t|
    t.integer "active_user_id"
    t.integer "passive_user_id"
    t.integer "active_reservation_id"
    t.integer "passive_reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_reservation_id"], name: "index_swap_reservations_on_active_reservation_id"
    t.index ["active_user_id", "passive_user_id", "passive_reservation_id", "active_reservation_id"], name: "swap_reservations_id", unique: true
    t.index ["active_user_id"], name: "index_swap_reservations_on_active_user_id"
    t.index ["passive_reservation_id"], name: "index_swap_reservations_on_passive_reservation_id"
    t.index ["passive_user_id"], name: "index_swap_reservations_on_passive_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.json "facebook"
    t.json "google"
    t.json "rating"
    t.json "invitations"
    t.integer "rooms_attended", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
