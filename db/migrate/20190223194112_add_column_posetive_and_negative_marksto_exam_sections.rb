class AddColumnPosetiveAndNegativeMarkstoExamSections < ActiveRecord::Migration[5.2]
  def change
    add_column :exam_sections, :positive_marks, :integer, null: false, default: 4
    add_column :exam_sections, :negative_marks, :integer, null: false, default: -1
  end
end
