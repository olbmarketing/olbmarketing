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

ActiveRecord::Schema.define(version: 20161122020017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "exit_surveys", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "how_likely_to_recommend"
    t.string   "how_satisfied_with_education"
    t.string   "how_is_spiritual_environment"
    t.string   "spiritual_environment_comment"
    t.string   "how_is_physical_facilities"
    t.string   "physical_facilities_comment"
    t.string   "how_is_academic_program"
    t.string   "academic_program_comment"
    t.string   "how_is_social_environment"
    t.string   "social_environment_comment"
    t.string   "how_is_admin_faculty_and_staff"
    t.string   "admin_faculty_and_staff_comment"
    t.string   "how_is_communication"
    t.string   "communication_comment"
    t.string   "reason_for_leaving"
    t.string   "reason_for_leaving_explan"
    t.string   "comments_questions_concerns"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["student_id"], name: "index_exit_surveys_on_student_id", using: :btree
  end

  create_table "parishes", force: :cascade do |t|
    t.string   "name"
    t.string   "contact"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "deanery"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "latitude"
    t.float    "longitude"
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
    t.index ["parish_id"], name: "index_schools_on_parish_id", using: :btree
  end

  create_table "star_tests", force: :cascade do |t|
    t.integer  "student_id"
    t.date     "test_date"
    t.integer  "scaled_score"
    t.string   "developmental_stage"
    t.integer  "alphabetic_principle"
    t.integer  "concept_of_word"
    t.integer  "visual_discrimination"
    t.integer  "phonemic_awareness"
    t.integer  "phonics"
    t.integer  "structural_analysis"
    t.integer  "vocabulary"
    t.integer  "sentence_level_comprehension"
    t.integer  "paragraph_level_comprehension"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "early_numeracy"
    t.index ["student_id"], name: "index_star_tests_on_student_id", using: :btree
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
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email1"
    t.string   "email2"
    t.text     "note"
    t.boolean  "alumni"
  end

  create_table "terra_nova_test_benchmarks", force: :cascade do |t|
    t.date     "test_date"
    t.integer  "oral_comprehension_opi"
    t.integer  "basic_understanding_opi"
    t.integer  "introduction_to_print_opi"
    t.integer  "number_and_number_relations_opi"
    t.integer  "measurement_opi"
    t.integer  "geometry_and_spatial_sense_opi"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "data_stats_and_probability_opi"
    t.string   "oral_comprehension_moderate_mastery_range"
    t.string   "basic_understanding_moderate_mastery_range"
    t.string   "introduction_to_print_moderate_mastery_range"
    t.string   "number_and_number_relations_moderate_mastery_range"
    t.string   "measurement_moderate_mastery_range"
    t.string   "geometry_and_spatial_sense_moderate_mastery_range"
    t.string   "data_stats_and_probability_moderate_mastery_range"
  end

  create_table "terra_nova_tests", force: :cascade do |t|
    t.integer  "student_id"
    t.date     "test_date"
    t.integer  "reading_scale_score"
    t.integer  "reading_national_percentile"
    t.integer  "oral_comprehension_opi"
    t.integer  "basic_understanding_opi"
    t.integer  "introduction_to_print_opi"
    t.integer  "math_scale_score"
    t.integer  "math_national_percentile"
    t.integer  "number_and_number_relations_opi"
    t.integer  "measurement_opi"
    t.integer  "geometry_and_spatial_sense_opi"
    t.integer  "data_stats_and_probability_opi"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["student_id"], name: "index_terra_nova_tests_on_student_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "exit_surveys", "students"
  add_foreign_key "schools", "parishes"
  add_foreign_key "star_tests", "students"
  add_foreign_key "terra_nova_tests", "students"
end
