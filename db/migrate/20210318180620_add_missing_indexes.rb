class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :admins, :org_id
    add_index :admins, [:id, :type]
    add_index :batches, :batch_group_id
    add_index :batches, :org_id
    add_index :exams, :org_id
    add_index :genres, :org_id
    add_index :genres, :subject_id
    add_index :new_admissions, :course_id
    add_index :questions, :section_id
    add_index :raw_attendances, :org_id
    add_index :student_exam_summaries, :student_exam_id
    add_index :students, :org_id
    add_index :video_lectures, :genre_id
    add_index :video_lectures, :org_id

    add_index :students, :api_key
    add_index :students, [:roll_number, :parent_mobile]
    add_index :orgs, :subdomain

    add_index :new_admissions, :payment_id
    add_index :new_admissions, :reference_id
    add_index :new_admissions, :rz_order_id
  end
end
