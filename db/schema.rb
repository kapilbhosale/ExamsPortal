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

ActiveRecord::Schema.define(version: 2020_05_08_150505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "add_table_batch_video_lecutrs", force: :cascade do |t|
    t.bigint "video_lecture_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_add_table_batch_video_lecutrs_on_batch_id"
    t.index ["video_lecture_id", "batch_id"], name: "vl_batch_index", unique: true
    t.index ["video_lecture_id"], name: "index_add_table_batch_video_lecutrs_on_video_lecture_id"
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

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
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "batch_notifications", force: :cascade do |t|
    t.bigint "notification_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_notifications_on_batch_id"
    t.index ["notification_id"], name: "index_batch_notifications_on_notification_id"
  end

  create_table "batch_study_pdfs", force: :cascade do |t|
    t.bigint "batch_id"
    t.bigint "study_pdf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_study_pdfs_on_batch_id"
    t.index ["study_pdf_id"], name: "index_batch_study_pdfs_on_study_pdf_id"
  end

  create_table "batch_video_lectures", force: :cascade do |t|
    t.bigint "video_lecture_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_video_lectures_on_batch_id"
    t.index ["video_lecture_id", "batch_id"], name: "batch_vl_index", unique: true
    t.index ["video_lecture_id"], name: "index_batch_video_lectures_on_video_lecture_id"
  end

  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_id", default: 0
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
    t.integer "negative_marks", default: -1, null: false
    t.integer "exam_type", default: 0
    t.datetime "show_exam_at"
    t.integer "org_id", default: 0
    t.index ["name"], name: "index_exams_on_name"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "org_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_notifications_on_org_id"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id"
    t.text "data"
    t.boolean "is_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_image", default: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "subdomain"
    t.string "about_us_link"
    t.string "fcm_server_key"
    t.string "vimeo_access_token"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "question_type", default: 0
    t.boolean "is_image", default: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_jee", default: false
    t.text "description"
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
    t.string "ans"
    t.jsonb "question_props", default: {}
    t.index ["option_id"], name: "index_student_exam_answers_on_option_id"
    t.index ["question_id"], name: "index_student_exam_answers_on_question_id"
    t.index ["student_exam_id", "question_id"], name: "index_student_exam_answers_on_student_exam_id_and_question_id", unique: true
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

  create_table "student_exam_syncs", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "exam_id"
    t.jsonb "sync_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_student_exam_syncs_on_exam_id"
    t.index ["student_id"], name: "index_student_exam_syncs_on_student_id"
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
    t.string "api_key"
    t.string "fcm_token"
    t.integer "org_id", default: 0
    t.index ["category_id"], name: "index_students_on_category_id"
    t.index ["name"], name: "index_students_on_name"
    t.index ["parent_mobile"], name: "index_students_on_parent_mobile"
  end

  create_table "study_pdfs", force: :cascade do |t|
    t.bigint "org_id"
    t.string "name"
    t.string "description"
    t.string "question_paper"
    t.string "solution_paper"
    t.integer "pdf_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_study_pdfs_on_org_id"
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

  create_table "video_lectures", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "video_id"
    t.string "description"
    t.string "thumbnail"
    t.string "by"
    t.string "tag"
    t.integer "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.integer "video_type", default: 0
    t.integer "org_id", default: 0
    t.string "uploaded_thumbnail"
  end

end
