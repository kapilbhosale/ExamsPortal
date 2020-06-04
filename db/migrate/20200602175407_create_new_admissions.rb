class CreateNewAdmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :new_admissions do |t|
      t.string  :first_name
      t.string  :middle_name
      t.string  :last_name
      t.string  :student_mobile
      t.string  :parent_mobile, null: false
      t.integer :gender, default: 0
      t.string  :email

      t.string  :city
      t.string  :district
      t.string  :school_name
      t.string  :last_exam_percentage
      t.text    :address

      t.string :payment_id
      t.integer :payment_status, default: 0

      t.integer :course_id

      t.timestamps
    end
  end
end
