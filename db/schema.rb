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

ActiveRecord::Schema.define(version: 20150104020249) do

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string   "name"
    t.string   "background_color"
    t.string   "text_color"
    t.integer  "entries_per_page"
    t.integer  "position"
    t.boolean  "show"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "portfolio_id"
  end

  add_index "columns", ["portfolio_id"], name: "index_columns_on_portfolio_id"

  create_table "entries", force: :cascade do |t|
    t.integer  "column_id"
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.boolean  "sticky"
    t.boolean  "title_link"
    t.boolean  "external_title_link"
    t.string   "external_url"
    t.string   "slug"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "portfolio_id"
  end

  add_index "entries", ["column_id"], name: "index_entries_on_column_id"
  add_index "entries", ["portfolio_id"], name: "index_entries_on_portfolio_id"

  create_table "entries_tags", id: false, force: :cascade do |t|
    t.integer "entry_id"
    t.integer "tag_id"
  end

  add_index "entries_tags", ["entry_id", "tag_id"], name: "index_entries_tags_on_entry_id_and_tag_id", unique: true

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id"

  create_table "portfolios", force: :cascade do |t|
    t.string   "title"
    t.string   "font"
    t.integer  "font_size",       default: 12
    t.boolean  "passworded"
    t.string   "password_digest"
    t.boolean  "pdf_enabled"
    t.boolean  "rss_enabled"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "admin_id"
    t.string   "url"
  end

  add_index "portfolios", ["admin_id"], name: "index_portfolios_on_admin_id"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "text_color"
    t.string   "background_color"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "portfolio_id"
  end

  add_index "tags", ["portfolio_id"], name: "index_tags_on_portfolio_id"

end
