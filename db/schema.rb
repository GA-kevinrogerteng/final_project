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

ActiveRecord::Schema.define(version: 20140328005807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feeds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "fb_id"
    t.string   "fb_type"
    t.string   "link"
    t.string   "story"
    t.string   "message"
    t.datetime "created_time"
    t.datetime "updated_time"
    t.string   "fb_uid"
    t.string   "fb_uid_from"
    t.string   "picture"
    t.string   "icon"
    t.string   "name"
    t.string   "object_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "local_photo_file_name"
    t.string   "local_photo_content_type"
    t.integer  "local_photo_file_size"
    t.datetime "local_photo_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "friends"
    t.string   "fb_id"
    t.string   "gender"
    t.string   "hometown"
    t.boolean  "installed"
    t.string   "language"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "locale"
    t.string   "name"
    t.string   "name_format"
    t.string   "political"
    t.string   "relationship_status"
    t.string   "religion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
