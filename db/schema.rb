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

ActiveRecord::Schema.define(version: 20131109052754) do

  create_table "action_types", force: true do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "point_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "business_name"
    t.string   "address"
    t.integer  "priority"
    t.string   "email"
    t.string   "contact_name"
    t.string   "telephone"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "year"
    t.string   "semester"
    t.string   "project_type"
    t.datetime "project_start"
    t.datetime "project_end"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts", force: true do |t|
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
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school_id"
    t.integer  "role"
    t.integer  "section"
    t.string   "parent_id"
    t.string   "email"
    t.integer  "extension"
  end

end
