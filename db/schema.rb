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

ActiveRecord::Schema.define(version: 20150805223933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "earnings", force: :cascade do |t|
    t.date    "earning_date",       null: false
    t.text    "description",        null: false
    t.string  "interval",           null: false
    t.string  "payment_count",      null: false
    t.string  "number_of_payments", null: false
    t.decimal "amount",             null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.date    "expense_date", null: false
    t.text    "description",  null: false
    t.text    "category",     null: false
    t.decimal "amount",       null: false
  end

  add_index "expenses", ["category"], name: "index_expenses_on_category", using: :btree

  create_table "goals", force: :cascade do |t|
    t.string   "title",          null: false
    t.decimal  "amount",         null: false
    t.date     "due_date",       null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "filepicker_url"
  end

end
