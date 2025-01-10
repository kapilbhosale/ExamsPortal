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

ActiveRecord::Schema.define(version: 2025_01_10_114006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
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

  create_table "admin_batches", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_admin_batches_on_admin_id"
    t.index ["batch_id"], name: "index_admin_batches_on_batch_id"
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
    t.integer "org_id", default: 0
    t.string "type", default: "Teacher"
    t.jsonb "roles", default: []
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["id", "type"], name: "index_admins_on_id_and_type"
    t.index ["org_id"], name: "index_admins_on_org_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "admission_batches", force: :cascade do |t|
  end

  create_table "att_machines", force: :cascade do |t|
    t.string "name", null: false
    t.string "ip_address", null: false
    t.boolean "disabled", default: false
    t.boolean "online", default: false
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_att_machines_on_org_id"
  end

  create_table "att_sms_logs", force: :cascade do |t|
    t.bigint "batch_id"
    t.integer "present_count"
    t.integer "absent_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode"
    t.index ["batch_id"], name: "index_att_sms_logs_on_batch_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "org_id"
    t.string "file_name"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
    t.index ["org_id"], name: "index_attachments_on_org_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "student_id"
    t.datetime "time_entry"
    t.integer "time_stamp"
    t.integer "att_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_attendances_on_org_id"
    t.index ["student_id"], name: "index_attendances_on_student_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.string "on_click_url"
    t.bigint "org_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_banners_on_org_id"
  end

  create_table "batch_banners", force: :cascade do |t|
    t.bigint "banner_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banner_id"], name: "index_batch_banners_on_banner_id"
    t.index ["batch_id"], name: "index_batch_banners_on_batch_id"
  end

  create_table "batch_fees_templates", force: :cascade do |t|
    t.bigint "fees_template_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_fees_templates_on_batch_id"
    t.index ["fees_template_id", "batch_id"], name: "batch_fees_template_index", unique: true
    t.index ["fees_template_id"], name: "index_batch_fees_templates_on_fees_template_id"
  end

  create_table "batch_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_batch_groups_on_org_id"
  end

  create_table "batch_holidays", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "batch_id"
    t.date "holiday_date"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_holidays_on_batch_id"
    t.index ["org_id"], name: "index_batch_holidays_on_org_id"
  end

  create_table "batch_micro_payments", force: :cascade do |t|
    t.bigint "micro_payment_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_micro_payments_on_batch_id"
    t.index ["micro_payment_id"], name: "index_batch_micro_payments_on_micro_payment_id"
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

  create_table "batch_zoom_meetings", force: :cascade do |t|
    t.bigint "zoom_meeting_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_batch_zoom_meetings_on_batch_id"
    t.index ["zoom_meeting_id"], name: "index_batch_zoom_meetings_on_zoom_meeting_id"
  end

  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_id", default: 0
    t.integer "batch_group_id"
    t.integer "students_count", default: 0
    t.integer "disable_count", default: 0
    t.datetime "start_time"
    t.datetime "end_time"
    t.jsonb "config"
    t.string "klass"
    t.string "device_ids"
    t.string "branch", default: "home"
    t.string "edu_year", default: "2024-25"
    t.index ["batch_group_id"], name: "index_batches_on_batch_group_id"
    t.index ["org_id"], name: "index_batches_on_org_id"
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

  create_table "course_change_entries", force: :cascade do |t|
    t.bigint "student_id"
    t.integer "old_batch_id", null: false
    t.integer "new_batch_id", null: false
    t.jsonb "fees_paid_data", null: false
    t.float "pending_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_course_change_entries_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "fees", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "org_id"
    t.string "type_of_discount"
    t.decimal "amount"
    t.string "comment"
    t.string "approved_by"
    t.string "status"
    t.string "student_name"
    t.string "parent_mobile"
    t.string "student_mobile"
    t.string "roll_number"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_discounts_on_org_id"
    t.index ["roll_number", "parent_mobile"], name: "index_discounts_on_roll_number_and_parent_mobile"
  end

  create_table "doubts", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "subject_id"
    t.integer "parent_id"
    t.string "details"
    t.boolean "is_solved", default: false
    t.integer "upvotes", default: 0
    t.bigint "admin_id"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_doubts_on_admin_id"
    t.index ["org_id"], name: "index_doubts_on_org_id"
    t.index ["student_id"], name: "index_doubts_on_student_id"
    t.index ["subject_id"], name: "index_doubts_on_subject_id"
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
    t.datetime "exam_available_till"
    t.boolean "is_pr_generated", default: false
    t.datetime "show_result_at"
    t.boolean "shuffle_questions", default: false, null: false
    t.index ["name"], name: "index_exams_on_name"
    t.index ["org_id"], name: "index_exams_on_org_id"
  end

  create_table "fees_templates", force: :cascade do |t|
    t.bigint "org_id"
    t.string "name"
    t.string "description"
    t.jsonb "heads", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_fees_templates_on_org_id"
  end

  create_table "fees_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "org_id"
    t.string "receipt_number", null: false
    t.bigint "student_id"
    t.string "academic_year"
    t.decimal "paid_amount", default: "0.0"
    t.decimal "remaining_amount", default: "0.0"
    t.decimal "discount_amount", default: "0.0"
    t.jsonb "payment_details", default: {}
    t.date "next_due_date"
    t.string "received_by"
    t.string "comment"
    t.string "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_of_the_day"
    t.integer "received_by_admin_id"
    t.boolean "imported", default: false
    t.datetime "deleted_at"
    t.boolean "is_headless", default: false
    t.index ["deleted_at"], name: "index_fees_transactions_on_deleted_at"
    t.index ["org_id"], name: "index_fees_transactions_on_org_id"
    t.index ["student_id"], name: "index_fees_transactions_on_student_id"
  end

  create_table "form_data", force: :cascade do |t|
    t.bigint "student_id"
    t.string "form_id"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_form_data_on_student_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.integer "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false
    t.integer "subject_id"
    t.integer "video_lectures_count", default: 0
    t.boolean "batch_assigned", default: false
    t.integer "study_pdfs_count", default: 0
    t.index ["org_id"], name: "index_genres_on_org_id"
    t.index ["subject_id"], name: "index_genres_on_subject_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "student_id"
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["student_id"], name: "index_likes_on_student_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.string "sender_type"
    t.string "sender_name"
    t.text "message"
    t.bigint "messageable_id"
    t.string "messageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id"
  end

  create_table "micro_payments", force: :cascade do |t|
    t.string "link", null: false
    t.decimal "amount"
    t.decimal "min_payable_amount"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["link"], name: "index_micro_payments_on_link", unique: true
    t.index ["org_id"], name: "index_micro_payments_on_org_id"
  end

  create_table "new_admissions", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "student_mobile"
    t.string "parent_mobile", null: false
    t.integer "gender", default: 0
    t.string "email"
    t.string "city"
    t.string "district"
    t.string "school_name"
    t.string "last_exam_percentage"
    t.text "address"
    t.string "payment_id"
    t.integer "payment_status", default: 0
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "batch", default: 0
    t.integer "rcc_branch", default: 0
    t.jsonb "payment_callback_data", default: {}
    t.string "error_code"
    t.string "error_info"
    t.string "reference_id"
    t.integer "student_id"
    t.text "prev_receipt_number"
    t.string "rz_order_id"
    t.decimal "fees", default: "0.0"
    t.integer "course_type", default: 0
    t.boolean "free", default: false
    t.jsonb "extra_data", default: {}
    t.string "status", default: "default"
    t.index ["course_id"], name: "index_new_admissions_on_course_id"
    t.index ["payment_id"], name: "index_new_admissions_on_payment_id"
    t.index ["reference_id"], name: "index_new_admissions_on_reference_id"
    t.index ["rz_order_id"], name: "index_new_admissions_on_rz_order_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "org_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "min_pay"
    t.index ["org_id"], name: "index_notes_on_org_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "org_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notif_types", default: 0
    t.string "attachment_pdf"
    t.string "attachment_image"
    t.index ["org_id"], name: "index_notifications_on_org_id"
  end

  create_table "omr_batch_tests", force: :cascade do |t|
    t.bigint "omr_batch_id"
    t.bigint "omr_test_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["omr_batch_id"], name: "index_omr_batch_tests_on_omr_batch_id"
    t.index ["omr_test_id", "omr_batch_id"], name: "index_omr_batch_tests_on_omr_test_id_and_omr_batch_id", unique: true
    t.index ["omr_test_id"], name: "index_omr_batch_tests_on_omr_test_id"
  end

  create_table "omr_batches", force: :cascade do |t|
    t.bigint "org_id"
    t.string "name"
    t.string "db_modified_date"
    t.string "branch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
    t.index ["name", "branch"], name: "index_omr_batches_on_name_and_branch", unique: true
    t.index ["org_id"], name: "index_omr_batches_on_org_id"
  end

  create_table "omr_student_batches", force: :cascade do |t|
    t.bigint "omr_student_id"
    t.bigint "omr_batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["omr_batch_id"], name: "index_omr_student_batches_on_omr_batch_id"
    t.index ["omr_student_id", "omr_batch_id"], name: "index_omr_student_batches_on_omr_student_id_and_omr_batch_id", unique: true
    t.index ["omr_student_id"], name: "index_omr_student_batches_on_omr_student_id"
  end

  create_table "omr_student_tests", force: :cascade do |t|
    t.bigint "omr_student_id"
    t.bigint "omr_test_id"
    t.integer "score", default: 0
    t.jsonb "student_ans", default: []
    t.integer "rank"
    t.integer "child_test_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}
    t.index ["omr_student_id", "omr_test_id"], name: "index_omr_student_tests_on_omr_student_id_and_omr_test_id", unique: true
    t.index ["omr_student_id"], name: "index_omr_student_tests_on_omr_student_id"
    t.index ["omr_test_id"], name: "index_omr_student_tests_on_omr_test_id"
  end

  create_table "omr_students", force: :cascade do |t|
    t.bigint "org_id"
    t.integer "student_id"
    t.integer "roll_number"
    t.string "parent_contact"
    t.string "student_contact"
    t.string "name"
    t.string "branch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_omr_students_on_deleted_at"
    t.index ["org_id"], name: "index_omr_students_on_org_id"
    t.index ["roll_number", "parent_contact", "deleted_at"], name: "index_omr_students_unique", unique: true
  end

  create_table "omr_tests", force: :cascade do |t|
    t.bigint "org_id"
    t.string "test_name", null: false
    t.string "description"
    t.integer "no_of_questions", default: 0
    t.integer "total_marks", default: 0
    t.datetime "test_date"
    t.jsonb "answer_key", default: {}
    t.integer "parent_id"
    t.string "db_modified_date"
    t.boolean "is_booklet", default: false
    t.boolean "is_combine", default: false
    t.string "branch"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "toppers", default: {}
    t.integer "old_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_omr_tests_on_deleted_at"
    t.index ["org_id"], name: "index_omr_tests_on_org_id"
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
    t.string "name"
    t.index ["subdomain"], name: "index_orgs_on_subdomain"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "student_id"
    t.decimal "amount"
    t.string "reference_number"
    t.integer "new_admission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_payment_transactions_on_student_id"
  end

  create_table "pending_fees", force: :cascade do |t|
    t.bigint "student_id"
    t.decimal "amount"
    t.boolean "paid", default: false
    t.integer "reference_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "block_videos", default: false
    t.index ["student_id"], name: "index_pending_fees_on_student_id"
  end

  create_table "photo_upload_logs", force: :cascade do |t|
    t.string "filename"
    t.integer "success_count"
    t.integer "not_found_count"
    t.jsonb "sucess_roll_numbers"
    t.jsonb "not_found_roll_numbers"
    t.string "uploaded_by"
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

  create_table "progress_reports", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "exam_id"
    t.boolean "is_imported", default: false
    t.integer "exam_type", default: 0
    t.date "exam_date"
    t.string "exam_name"
    t.decimal "percentage"
    t.integer "rank"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "omr", default: false
    t.integer "org_id"
    t.index ["exam_id"], name: "index_progress_reports_on_exam_id"
    t.index ["student_id"], name: "index_progress_reports_on_student_id"
  end

  create_table "proxies", force: :cascade do |t|
    t.string "user_name"
    t.string "password"
    t.string "ip_and_port"
    t.string "conn_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["section_id"], name: "index_questions_on_section_id"
  end

  create_table "raw_attendances", force: :cascade do |t|
    t.jsonb "data", default: {}
    t.boolean "processed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_id"
    t.index ["org_id"], name: "index_raw_attendances_on_org_id"
  end

  create_table "roll_number_suggestors", force: :cascade do |t|
    t.string "batch_name"
    t.string "criteria"
    t.integer "initial_suggested"
    t.integer "last_suggested"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "input_questions_present", default: false
    t.integer "correct_input_questions", default: 0
    t.integer "incorrect_input_questions", default: 0
    t.integer "total_score", default: 0
    t.jsonb "extra_data", default: {}
    t.index ["section_id"], name: "index_student_exam_summaries_on_section_id"
    t.index ["student_exam_id", "section_id"], name: "index_student_exam_summaries_on_student_exam_id_and_section_id", unique: true
    t.index ["student_exam_id"], name: "index_student_exam_summaries_on_student_exam_id"
  end

  create_table "student_exam_syncs", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "exam_id"
    t.jsonb "sync_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "end_exam_sync", default: false
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

  create_table "student_notes", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "student_id"
    t.bigint "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_student_notes_on_note_id"
    t.index ["org_id"], name: "index_student_notes_on_org_id"
    t.index ["student_id"], name: "index_student_notes_on_student_id"
  end

  create_table "student_payments", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "micro_payment_id"
    t.string "rz_order_id"
    t.decimal "amount"
    t.integer "status", default: 0
    t.jsonb "raw_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["micro_payment_id"], name: "index_student_payments_on_micro_payment_id"
    t.index ["student_id"], name: "index_student_payments_on_student_id"
  end

  create_table "student_video_folders", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "show_till_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_student_video_folders_on_genre_id"
    t.index ["student_id"], name: "index_student_video_folders_on_student_id"
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
    t.boolean "app_login", default: false
    t.string "deviceUniqueId"
    t.string "deviceName"
    t.string "manufacturer"
    t.string "brand"
    t.integer "new_admission_id"
    t.boolean "is_laptop_login", default: false
    t.integer "access_type", default: 0
    t.integer "suggested_roll_number"
    t.integer "app_reset_count", default: 0
    t.datetime "deleted_at"
    t.boolean "disable", default: false
    t.string "rfid_card_number"
    t.string "exam_hall"
    t.jsonb "data", default: {}
    t.integer "intel_score"
    t.jsonb "id_card", default: []
    t.index ["api_key"], name: "index_students_on_api_key"
    t.index ["category_id"], name: "index_students_on_category_id"
    t.index ["deleted_at"], name: "index_students_on_deleted_at"
    t.index ["name"], name: "index_students_on_name"
    t.index ["org_id"], name: "index_students_on_org_id"
    t.index ["parent_mobile"], name: "index_students_on_parent_mobile"
    t.index ["roll_number", "parent_mobile"], name: "index_students_on_roll_number_and_parent_mobile", unique: true
    t.index ["roll_number"], name: "index_students_on_roll_number"
  end

  create_table "study_pdf_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "pdf_type", default: 0, null: false
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_study_pdf_types_on_org_id"
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
    t.integer "study_pdf_type_id"
    t.bigint "genre_id"
    t.bigint "subject_id"
    t.index ["genre_id"], name: "index_study_pdfs_on_genre_id"
    t.index ["org_id"], name: "index_study_pdfs_on_org_id"
    t.index ["study_pdf_type_id"], name: "index_study_pdfs_on_study_pdf_type_id"
    t.index ["subject_id"], name: "index_study_pdfs_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_map", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "org_id"
    t.string "klass"
    t.index ["name_map"], name: "index_subjects_on_name_map"
    t.index ["org_id"], name: "index_subjects_on_org_id"
  end

  create_table "super_admins", force: :cascade do |t|
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
    t.index ["email"], name: "index_super_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_super_admins_on_reset_password_token", unique: true
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

  create_table "trackers", force: :cascade do |t|
    t.bigint "student_id"
    t.string "resource_type"
    t.integer "resource_id"
    t.integer "event"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "device_type", default: 0
    t.index ["student_id"], name: "index_trackers_on_student_id"
  end

  create_table "video_lectures", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "video_id"
    t.string "description"
    t.string "thumbnail"
    t.string "by"
    t.string "tag"
    t.integer "subject_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
    t.integer "video_type", default: 0
    t.integer "org_id", default: 0
    t.string "uploaded_thumbnail"
    t.integer "laptop_vimeo_id"
    t.integer "genre_id", default: 0
    t.integer "subject_id"
    t.datetime "publish_at"
    t.integer "view_limit", default: 3
    t.string "play_url_from_server"
    t.datetime "link_udpated_at"
    t.datetime "hide_at"
    t.string "yt_video_id"
    t.string "tp_streams_id"
    t.jsonb "tp_streams_data", default: {}
    t.index ["genre_id"], name: "index_video_lectures_on_genre_id"
    t.index ["org_id"], name: "index_video_lectures_on_org_id"
    t.index ["subject_id"], name: "index_video_lectures_on_subject_id"
  end

  create_table "whats_apps", force: :cascade do |t|
    t.string "phone_number"
    t.string "message"
    t.string "var_1"
    t.string "var_2"
    t.string "var_3"
    t.string "var_4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zoom_meetings", force: :cascade do |t|
    t.string "zoom_meeting_id"
    t.string "password"
    t.datetime "datetime_of_meeting"
    t.string "subject"
    t.string "teacher_name"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "live_type", default: 0
    t.string "vimeo_live_url"
    t.string "vimeo_live_show_url"
    t.string "zoom_meeting_url"
    t.index ["org_id"], name: "index_zoom_meetings_on_org_id"
  end

  add_foreign_key "omr_batches", "orgs"
  add_foreign_key "omr_students", "orgs"
  add_foreign_key "omr_tests", "orgs"
  add_foreign_key "study_pdfs", "subjects"
end
