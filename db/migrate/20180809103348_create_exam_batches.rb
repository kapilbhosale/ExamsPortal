class CreateExamBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :exam_batches do |t|
      t.references :exam
      t.references :batch

      t.timestamps
    end
  end
end
