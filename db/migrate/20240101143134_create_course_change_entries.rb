class CreateCourseChangeEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :course_change_entries do |t|
      t.references :student
      t.integer :old_batch_id, null: false
      t.integer :new_batch_id, null: false
      t.jsonb   :fees_paid_data, null: false
      t.float   :pending_amount, null: false
      t.timestamps
    end
  end
end
