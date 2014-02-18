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

ActiveRecord::Schema.define(version: 20140217220445) do

  create_table "action_types", force: true do |t|
    t.string   "name",        null: false
    t.integer  "role",        null: false
    t.integer  "point_value", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "action_types", ["name"], name: "index_action_types_on_name", unique: true, using: :btree

  create_table "actions", force: true do |t|
    t.integer  "points_earned",    null: false
    t.datetime "user_action_time", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "action_type_id",   null: false
    t.integer  "receipt_id",       null: false
    t.text     "comment"
  end

  add_index "actions", ["action_type_id"], name: "index_actions_on_action_type_id", using: :btree
  add_index "actions", ["receipt_id"], name: "index_actions_on_receipt_id", using: :btree

  create_table "bonus", force: true do |t|
    t.integer  "points",     default: 0, null: false
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",             null: false
    t.integer  "user_id",                null: false
  end

  add_index "bonus", ["project_id"], name: "index_bonus_on_project_id", using: :btree
  add_index "bonus", ["user_id"], name: "index_bonus_on_user_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "business_name",            null: false
    t.string   "address"
    t.string   "email"
    t.string   "telephone"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.integer  "zipcode"
    t.string   "contact_fname", limit: 30
    t.string   "contact_lname", limit: 30
    t.string   "contact_title", limit: 10
    t.string   "city",          limit: 30
    t.string   "state",         limit: 2
    t.integer  "status_id"
    t.string   "submitter"
  end

  add_index "clients", ["business_name"], name: "index_clients_on_business_name", unique: true, using: :btree
  add_index "clients", ["status_id"], name: "index_clients_on_status_id", using: :btree

  create_table "comments", force: true do |t|
    t.text    "body"
    t.integer "ticket_id"
    t.integer "user_id"
  end

  add_index "comments", ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "members", force: true do |t|
    t.integer  "section_number",                null: false
    t.boolean  "is_enabled",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                       null: false
    t.integer  "project_id",                    null: false
    t.integer  "parent_id"
  end

  add_index "members", ["parent_id"], name: "index_members_on_parent_id", using: :btree
  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

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
    t.datetime "tickets_open_time"
    t.datetime "tickets_close_time"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_clients",                 limit: 2
    t.integer  "max_high_priority_clients",   limit: 2
    t.integer  "max_low_priority_clients",    limit: 2
    t.integer  "max_medium_priority_clients", limit: 2
    t.boolean  "use_max_clients"
    t.integer  "project_type_id"
    t.boolean  "is_active"
  end

  create_table "receipts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_id",                         null: false
    t.integer  "user_id",                           null: false
    t.boolean  "made_contact",      default: false
    t.boolean  "made_presentation", default: false
    t.boolean  "made_sale",         default: false
    t.float    "sale_value"
    t.float    "page_size"
    t.string   "payment_type"
  end

  create_table "statuses", force: true do |t|
    t.string   "status_type",    limit: 30
    t.boolean  "status_enabled",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "priority_id"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school_id"
    t.integer  "role"
    t.string   "email"
    t.string   "phone"
    t.string   "first_name",     limit: 30
    t.string   "last_name",      limit: 30
    t.integer  "box"
    t.string   "major",          limit: 75
    t.string   "minor",          limit: 75
    t.string   "classification", limit: 10
    t.string   "remember_token"
    t.boolean  "help"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["school_id"], name: "index_users_on_school_id", unique: true, using: :btree

end
