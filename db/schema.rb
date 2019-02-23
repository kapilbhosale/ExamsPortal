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

ActiveRecord::Schema.define(version: 2019_02_23_194112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.bigint "institute_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["institute_id"], name: "index_admins_on_institute_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "component_styles", force: :cascade do |t|
    t.string "component_type"
    t.bigint "component_id"
    t.text "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_type", "component_id"], name: "index_component_styles_on_component_type_and_component_id"
  end

  create_table "concepts", force: :cascade do |t|
    t.bigint "subject_id"
    t.string "name", null: false
    t.string "name_map", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weightage", default: 0
    t.index ["name_map"], name: "index_concepts_on_name_map"
    t.index ["subject_id"], name: "index_concepts_on_subject_id"
  end

  create_table "exam_batches", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_exam_batches_on_batch_id"
    t.index ["exam_id"], name: "index_exam_batches_on_exam_id"
  end

  create_table "exam_questions", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_questions_on_exam_id"
    t.index ["question_id"], name: "index_exam_questions_on_question_id"
  end

  create_table "exam_sections", force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "positive_marks", default: 4, null: false
    t.integer "negative_marks", default: -1, null: false
    t.index ["exam_id"], name: "index_exam_sections_on_exam_id"
    t.index ["section_id"], name: "index_exam_sections_on_section_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "no_of_questions"
    t.integer "time_in_minutes"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "publish_result", default: false, null: false
    t.integer "positive_marks", default: 4, null: false
    t.integer "negative_marks", default: 1, null: false
    t.index ["name"], name: "index_exams_on_name"
  end

  create_table "institutes", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id"
    t.text "data"
    t.boolean "is_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "practice_questions", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "question_id"
    t.string "hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash"], name: "index_practice_questions_on_hash"
    t.index ["question_id"], name: "index_practice_questions_on_question_id"
    t.index ["topic_id"], name: "index_practice_questions_on_topic_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "title"
    t.text "explanation"
    t.integer "difficulty_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id", default: 1
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_batches", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_student_batches_on_batch_id"
    t.index ["student_id", "batch_id"], name: "index_student_batches_on_student_id_and_batch_id", unique: true
    t.index ["student_id"], name: "index_student_batches_on_student_id"
  end

  create_table "student_exam_answers", force: :cascade do |t|
    t.bigint "student_exam_id"
    t.bigint "question_id"
    t.bigint "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_student_exam_answers_on_option_id"
    t.index ["question_id"], name: "index_student_exam_answers_on_question_id"
    t.index ["student_exam_id"], name: "index_student_exam_answers_on_student_exam_id"
  end

  create_table "student_exam_summaries", force: :cascade do |t|
    t.bigint "student_exam_id"
    t.bigint "section_id"
    t.integer "no_of_questions"
    t.integer "answered"
    t.integer "not_answered"
    t.integer "correct"
    t.integer "incorrect"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_student_exam_summaries_on_section_id"
    t.index ["student_exam_id", "section_id"], name: "index_student_exam_summaries_on_student_exam_id_and_section_id", unique: true
  end

  create_table "student_exams", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "exam_id"
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_student_exams_on_exam_id"
    t.index ["student_id"], name: "index_student_exams_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "roll_number", null: false
    t.string "name", null: false
    t.string "mother_name"
    t.date "date_of_birth"
    t.integer "gender", limit: 2, default: 0
    t.float "ssc_marks"
    t.string "student_mobile", limit: 20
    t.string "parent_mobile", limit: 20, null: false
    t.text "address"
    t.string "college"
    t.string "photo"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "raw_password"
    t.index ["category_id"], name: "index_students_on_category_id"
    t.index ["name"], name: "index_students_on_name"
    t.index ["parent_mobile"], name: "index_students_on_parent_mobile"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_map", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_map"], name: "index_subjects_on_name_map"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "concept_id"
    t.string "name", null: false
    t.string "name_map", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_topics_on_concept_id"
    t.index ["name_map"], name: "index_topics_on_name_map"
  end

end
