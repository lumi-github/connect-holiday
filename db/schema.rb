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

ActiveRecord::Schema.define(version: 20180411222513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_books_on_event_id", using: :btree
    t.index ["user_id"], name: "index_books_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.boolean  "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "eigo_name"
    t.string   "furigana"
    t.boolean  "state"
    t.integer  "prefecture_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "event_photos", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["event_id"], name: "index_event_photos_on_event_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer  "accept_user_limit"
    t.integer  "price"
    t.string   "hash_tag"
    t.string   "movie"
    t.string   "place"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "state",             default: false
    t.integer  "user_id"
    t.integer  "prefecture_id"
    t.integer  "city_id"
    t.integer  "category_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["category_id"], name: "index_events_on_category_id", using: :btree
    t.index ["city_id"], name: "index_events_on_city_id", using: :btree
    t.index ["prefecture_id"], name: "index_events_on_prefecture_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "holidays", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.boolean  "allday"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_id"], name: "index_holidays_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "prefectures", force: :cascade do |t|
    t.string   "name"
    t.string   "eigo_name"
    t.string   "furigana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "target_id"
    t.boolean  "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id"], name: "index_relationships_on_target_id", using: :btree
    t.index ["user_id", "target_id", "type"], name: "index_relationships_on_user_id_and_target_id_and_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_relationships_on_user_id", using: :btree
  end

  create_table "user_photos", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "priority",           default: false
    t.index ["user_id"], name: "index_user_photos_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "gender"
    t.date     "birthday"
    t.string   "message"
    t.text     "comment"
    t.boolean  "admin"
    t.integer  "prefecture_id"
    t.integer  "city_id"
    t.integer  "notice_time"
    t.string   "publishable_key"
    t.string   "secret_key"
    t.string   "stripe_user_id"
    t.string   "currency"
    t.string   "stripe_account_type"
    t.index ["city_id"], name: "index_users_on_city_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["prefecture_id"], name: "index_users_on_prefecture_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "books", "events"
  add_foreign_key "books", "users"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "event_photos", "events"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "cities"
  add_foreign_key "events", "prefectures"
  add_foreign_key "events", "users"
  add_foreign_key "holidays", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "relationships", "users"
  add_foreign_key "relationships", "users", column: "target_id"
  add_foreign_key "user_photos", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "prefectures"
end
