class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.integer     :roll_number, null: false, unique: true
      t.string      :name, null: false
      t.string      :mother_name
      t.date        :date_of_birth
      t.integer     :gender, limit: 1, default: 0
      t.float       :ssc_marks
      t.string      :student_mobile, limit: 20
      t.string      :parent_mobile, limit: 20, null: false
      t.text        :address
      t.string      :college
      t.string      :photo
      t.references  :category

      t.timestamps
    end

    add_index :students, :name
    add_index :students, :parent_mobile
  end
end
