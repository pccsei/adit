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

ActiveRecord::Schema.define(version: 20140412153916) do

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
    t.string   "telephone"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zipcode"
    t.string   "contact_fname", limit: 30
    t.string   "contact_lname", limit: 30
    t.string   "contact_title", limit: 10
    t.string   "city",          limit: 30
    t.string   "state",         limit: 2
    t.integer  "status_id"
    t.string   "submitter"
    t.integer  "parent_id"
    t.string   "email"
  end

  add_index "clients", ["status_id"], name: "index_clients_on_status_id", using: :btree

  create_table "comments", force: true do |t|
    t.text    "body",      null: false
    t.integer "ticket_id", null: false
    t.integer "user_id",   null: false
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
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "priorities", ["name"], name: "index_priorities_on_name", unique: true, using: :btree

  create_table "project_types", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_types", ["name"], name: "index_project_types_on_name", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.integer  "year",                                       null: false
    t.string   "semester",                                   null: false
    t.datetime "tickets_open_time",                          null: false
    t.datetime "tickets_close_time",                         null: false
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_clients",                 default: 5,    null: false
    t.integer  "max_high_priority_clients",   default: 0,    null: false
    t.integer  "max_low_priority_clients",    default: 0,    null: false
    t.integer  "max_medium_priority_clients", default: 0,    null: false
    t.integer  "project_type_id",                            null: false
    t.boolean  "is_active",                   default: true, null: false
  end

  add_index "projects", ["project_type_id"], name: "index_projects_on_project_type_id", using: :btree
  add_index "projects", ["year", "project_type_id", "semester"], name: "index_projects_on_year_and_project_type_id_and_semester", unique: true, using: :btree

  create_table "receipts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_id",                         null: false
    t.integer  "user_id",                           null: false
    t.boolean  "made_contact",      default: false, null: false
    t.boolean  "made_presentation", default: false, null: false
    t.boolean  "made_sale",         default: false, null: false
    t.float    "sale_value"
    t.float    "page_size"
    t.string   "payment_type"
  end

  add_index "receipts", ["ticket_id", "user_id"], name: "index_receipts_on_ticket_id_and_user_id", unique: true, using: :btree
  add_index "receipts", ["ticket_id"], name: "index_receipts_on_ticket_id", using: :btree
  add_index "receipts", ["user_id"], name: "index_receipts_on_user_id", using: :btree

  create_table "statuses", force: true do |t|
    t.string   "status_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["status_type"], name: "index_statuses_on_status_type", unique: true, using: :btree

  create_table "tickets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",  null: false
    t.integer  "client_id",   null: false
    t.integer  "user_id"
    t.integer  "priority_id", null: false
  end

  add_index "tickets", ["client_id", "project_id"], name: "index_tickets_on_client_id_and_project_id", unique: true, using: :btree
  add_index "tickets", ["client_id"], name: "index_tickets_on_client_id", using: :btree
  add_index "tickets", ["priority_id"], name: "index_tickets_on_priority_id", using: :btree
  add_index "tickets", ["project_id"], name: "index_tickets_on_project_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

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
    t.string   "school_id",                                 null: false
    t.integer  "role",                                      null: false
    t.string   "email"
    t.string   "phone"
    t.string   "first_name",     limit: 30
    t.string   "last_name",      limit: 30
    t.integer  "box"
    t.string   "major",          limit: 75
    t.string   "minor",          limit: 75
    t.string   "classification", limit: 10
    t.string   "remember_token"
    t.boolean  "help",                      default: false, null: false
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["school_id"], name: "index_users_on_school_id", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
