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

ActiveRecord::Schema.define(version: 20150422103211) do

  create_table "admins", force: :cascade do |t|
    t.string   "account"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "hourly_wages", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "wage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hourly_wages", ["user_id"], name: "index_hourly_wages_on_user_id"

  create_table "time_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "original_start_at"
    t.datetime "original_end_at"
    t.integer  "modified_by_admin_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "time_logs", ["user_id"], name: "index_time_logs_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "account"
    t.string   "password_digest"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "password_changed"
  end

end
