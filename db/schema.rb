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

ActiveRecord::Schema.define(version: 20131127020918) do

  create_table "action_types", force: true do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "point_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", force: true do |t|
    t.integer  "points_earned"
    t.datetime "user_action_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "update_id"
    t.integer  "action_type_id"
    t.integer  "receipt_id"
  end

  create_table "bonus", force: true do |t|
    t.integer  "points"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "user_id"
  end

  create_table "clients", force: true do |t|
    t.string   "business_name"
    t.string   "address"
    t.string   "email"
    t.string   "telephone"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.integer  "status",        limit: 2
    t.integer  "zipcode"
    t.string   "contact_fname", limit: 30
    t.string   "contact_lname", limit: 30
    t.string   "contact_title", limit: 10
    t.string   "city",          limit: 30
    t.string   "state",         limit: 2
    t.integer  "status_id"
  end

  add_index "clients", ["status_id"], name: "index_clients_on_status_id", using: :btree

  create_table "priorities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "year"
    t.string   "semester"
    t.datetime "project_start"
    t.datetime "project_end"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_clients",        limit: 2
    t.integer  "max_green_clients",  limit: 2
    t.integer  "max_white_clients",  limit: 2
    t.integer  "max_yellow_clients", limit: 2
    t.boolean  "use_max_clients"
    t.integer  "project_type_id"
    t.boolean  "is_current_project"
  end

  create_table "receipts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_id"
    t.integer  "user_id"
  end

  create_table "statuses", force: true do |t|
    t.string   "status_type",    limit: 30
    t.boolean  "status_enabled",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.float    "sale_value"
    t.float    "page_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_type"
    t.binary   "attachment"
    t.string   "attachment_name"
    t.integer  "project_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "priority_id"
  end

  create_table "updates", force: true do |t|
    t.boolean  "is_public"
    t.string   "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "receipt_id"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school_id"
    t.integer  "role"
    t.integer  "section"
    t.string   "parent_id"
    t.string   "email"
    t.string   "phone"
    t.string   "first_name",     limit: 30
    t.string   "last_name",      limit: 30
    t.integer  "box"
    t.string   "major",          limit: 75
    t.string   "minor",          limit: 75
    t.string   "classification", limit: 10
  end

end
