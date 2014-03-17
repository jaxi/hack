# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140317121418) do

  create_table "airports", force: true do |t|
    t.string   "airport_id"
    t.string   "airport_name"
    t.string   "city_id"
    t.string   "city_name"
    t.string   "country_id"
    t.string   "country_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "airports", ["airport_name"], name: "index_airports_on_airport_name", using: :btree
  add_index "airports", ["city_name"], name: "index_airports_on_city_name", using: :btree
  add_index "airports", ["country_name"], name: "index_airports_on_country_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wishlists", force: true do |t|
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.date     "start_at"
    t.date     "end_at"
    t.boolean  "state"
    t.string   "name"
    t.decimal  "budget",     precision: 8, scale: 2
    t.text     "result"
    t.boolean  "sms_state"
    t.string   "token"
    t.integer  "position"
  end

  add_index "wishlists", ["user_id"], name: "index_wishlists_on_user_id", using: :btree

end
