class CreateExamSections < ActiveRecord::Migration[5.2]
  def change
    create_table :exam_sections do |t|
      t.references :exam
      t.references :section
      t.timestamps
    end
  end
end
