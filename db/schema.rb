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

ActiveRecord::Schema.define(version: 20170302064521) do

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "diagnostic_templates", force: :cascade do |t|
    t.string  "project_body", limit: 255
    t.integer "report_type",  limit: 4
    t.string  "symptom",      limit: 255
    t.text    "expression",   limit: 65535
    t.string  "diagnose",     limit: 255
  end

  create_table "dic_hospitals", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "pinyin",      limit: 255
    t.integer  "province_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level",       limit: 4
    t.integer  "city_id",     limit: 4
    t.decimal  "lng",                     precision: 12, scale: 8
    t.decimal  "lat",                     precision: 12, scale: 8
    t.string   "address",     limit: 255
    t.string   "_id",         limit: 255
    t.integer  "nature",      limit: 4,                            default: 0
  end

  add_index "dic_hospitals", ["level"], name: "index_dic_hospitals_on_level", using: :btree

  create_table "foursomes", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "haodaifu_departments", force: :cascade do |t|
    t.string "name",      limit: 255
    t.string "url",       limit: 255
    t.string "category",  limit: 255
    t.string "h_type",    limit: 255
    t.string "h_provice", limit: 255
    t.string "h_area",    limit: 255
    t.string "h_name",    limit: 255
  end

  create_table "haodaifu_hospitals", force: :cascade do |t|
    t.string "name",    limit: 255
    t.string "url",     limit: 255
    t.string "h_area",  limit: 255
    t.string "h_type",  limit: 255
    t.string "h_grade", limit: 255
  end

  create_table "haodaifu_provinces", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url",  limit: 255
  end

  create_table "hqm_dic_compared", force: :cascade do |t|
    t.string   "provinceId",  limit: 255
    t.string   "hName",       limit: 255
    t.string   "hGrade",      limit: 255
    t.string   "hType",       limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "proviceName", limit: 127
    t.boolean  "hasdic",                  default: false
  end

  create_table "hqms", force: :cascade do |t|
    t.string   "provinceId",  limit: 255
    t.string   "hName",       limit: 255
    t.string   "hGrade",      limit: 255
    t.string   "hType",       limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "proviceName", limit: 127
    t.boolean  "hasdic",                  default: false
  end

  create_table "my_hospitals", force: :cascade do |t|
    t.string "name",          limit: 255
    t.string "address",       limit: 255
    t.string "h_type",        limit: 255
    t.string "grade",         limit: 255
    t.string "amap_address",  limit: 255
    t.string "amap_location", limit: 255
    t.string "amap_tel",      limit: 255
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url",  limit: 255
    t.string "alt",  limit: 255
    t.string "mark", limit: 255
  end

  create_table "vegetables", force: :cascade do |t|
    t.string "name",      limit: 255
    t.string "min_val",   limit: 255
    t.string "ave_val",   limit: 255
    t.string "max_val",   limit: 255
    t.string "v_type",    limit: 255
    t.string "unit",      limit: 255
    t.string "send_date", limit: 255
  end

  create_table "xingrens", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "title",          limit: 255
    t.string   "administrative", limit: 255
    t.string   "area",           limit: 255
    t.text     "work_time",      limit: 65535
    t.string   "head",           limit: 255
    t.text     "description",    limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "yeah", id: false, force: :cascade do |t|
    t.string "name", limit: 255
  end

end
