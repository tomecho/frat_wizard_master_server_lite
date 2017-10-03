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

ActiveRecord::Schema.define(version: 20170910215320) do

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer  "event_id_id"
    t.integer  "user_id_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "points_earned"
    t.index ["event_id_id"], name: "index_attendances_on_event_id_id"
    t.index ["user_id_id"], name: "index_attendances_on_user_id_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "point_reward"
    t.string   "name"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "creator_id_id"
    t.integer  "address_id"
    t.integer  "org_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "long"
    t.string "lat"
    t.string "description"
  end

  create_table "orgs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

end
