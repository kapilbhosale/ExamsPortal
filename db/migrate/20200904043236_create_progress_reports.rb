class CreateProgressReports < ActiveRecord::Migration[5.2]
  def change
    create_table :progress_reports do |t|
      t.references  :student
      t.references  :exam
      t.boolean     :is_imported, default: false
      t.integer     :exam_type, default: 0
      t.date        :exam_date
      t.string      :exam_name
      t.decimal     :percentage
      t.integer     :rank
      t.jsonb       :data, default: {}
      t.timestamps
    end
  end
end
