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

ActiveRecord::Schema.define(version: 20160929134845) do

  create_table "employees", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email_personal"
    t.string   "email_work"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "parishes", force: :cascade do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "denery"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.integer  "parish_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parish_id"], name: "index_schools_on_parish_id"
  end

  create_table "star_tests", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "test_date"
    t.string   "scaled_score"
    t.string   "developmental_stage"
    t.string   "alphabetic_principle"
    t.string   "concept_of_word"
    t.string   "visual_discrimination"
    t.string   "phonemic_awareness"
    t.string   "phonics"
    t.string   "structural_analysis"
    t.string   "vocabulary"
    t.string   "sentence_level_comprehension"
    t.string   "paragraph_level_comprehension"
    t.string   "early_numeracy"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "school_year"
    t.string   "new_or_return"
    t.string   "student_class"
    t.string   "catholic"
    t.string   "parish"
    t.string   "race"
    t.string   "resides_with"
    t.string   "reference_from"
    t.string   "student_transfer"
    t.string   "preK_to_K"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
