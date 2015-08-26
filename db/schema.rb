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

ActiveRecord::Schema.define(version: 20150826101359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "category_title", limit: 64, null: false
  end

  add_index "categories", ["category_title"], name: "index_categories_on_category_title", unique: true, using: :btree

  create_table "entries", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.string   "title",           limit: 64
    t.string   "content",         limit: 255,             null: false
    t.integer  "content_type",    limit: 2,   default: 0, null: false
    t.integer  "user_id",                                 null: false
    t.integer  "category_id"
    t.integer  "parent_entry_id"
  end

  add_index "entries", ["category_id"], name: "index_entries_on_category_id", using: :btree
  add_index "entries", ["parent_entry_id"], name: "index_entries_on_parent_entry_id", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "favorites", ["entry_id", "user_id"], name: "index_favorites_on_entry_id_and_user_id", unique: true, using: :btree
  add_index "favorites", ["entry_id"], name: "index_favorites_on_entry_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.integer "entry_id",             null: false
    t.string  "tag_title", limit: 64, null: false
  end

  add_index "tags", ["entry_id", "tag_title"], name: "index_tags_on_entry_id_and_tag_title", unique: true, using: :btree
  add_index "tags", ["entry_id"], name: "index_tags_on_entry_id", using: :btree
  add_index "tags", ["tag_title"], name: "index_tags_on_tag_title", using: :btree

  create_table "users", force: :cascade do |t|
    t.string  "auth_provider",                 null: false
    t.string  "auth_uid",                      null: false
    t.string  "display_name",                  null: false
    t.string  "username",                      null: false
    t.boolean "is_admin",      default: false, null: false
    t.boolean "is_banned",     default: false, null: false
    t.string  "session_key"
  end

  add_index "users", ["auth_provider", "auth_uid"], name: "index_users_on_auth_provider_and_auth_uid", unique: true, using: :btree
  add_index "users", ["session_key"], name: "index_users_on_session_key", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "entries", "categories", on_delete: :nullify
  add_foreign_key "entries", "entries", column: "parent_entry_id", on_delete: :nullify
  add_foreign_key "entries", "users", on_delete: :cascade
  add_foreign_key "favorites", "entries", on_delete: :cascade
  add_foreign_key "favorites", "users", on_delete: :cascade
  add_foreign_key "tags", "entries", on_delete: :cascade
end
